using UnityEngine;
using UnityEngine.UI;
using UnityEngine.EventSystems;
using Kemika.Data;
using Kemika.Interaction;
using Kemika.Modes;
using Kemika.Localization;

namespace Kemika.Bootstrap
{
    // Builds the entire chloride + AgNO3 vertical slice at runtime -- no scene authoring
    // required. This exists so the project can be verified end-to-end (open project,
    // press Play) without needing to assemble anything by hand in the Unity Editor.
    // See TODO.md, "Vertical slice: chloride detection", for what this covers and what's
    // deliberately left for later (Kemidex, Challenge Mode, protagonist, real art).
    public static class SliceBootstrap
    {
        [RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.AfterSceneLoad)]
        private static void Run()
        {
            EnsureEventSystem();
            var canvas = CreateCanvas();

            var reaction = BuildChlorideVsSilverNitrateReaction();
            var controller = new PracticeModeController(reaction);

            var beaker = CreateBeaker(canvas.transform);
            var instructionText = CreateBannerText(canvas.transform, new Vector2(0, 0.85f), new Vector2(1, 0.95f));
            var feedbackText = CreateBannerText(canvas.transform, new Vector2(0, 0.72f), new Vector2(1, 0.80f));
            CreateDropper(canvas.transform, beaker, reaction.reagent, controller);
            var recordButton = CreateRecordButton(canvas.transform);

            instructionText.text = LocalizedStrings.Get("slice.instruction");

            controller.OnProgressChanged += progress =>
            {
                beaker.color = Color.Lerp(Color.white, reaction.resultColor, progress);
            };
            controller.OnReadyToRecord += () =>
            {
                recordButton.interactable = true;
                instructionText.text = LocalizedStrings.Get("slice.recordPrompt");
            };
            recordButton.onClick.AddListener(() =>
                CreateObservationPanel(canvas.transform, controller, reaction, feedbackText));
        }

        private static Reaction BuildChlorideVsSilverNitrateReaction()
        {
            var chloride = IonSpecies.Create("cl-", "Chloride (Cl⁻)", "كلوريد (Cl⁻)", IonCategory.Anion);
            var silverNitrate = Reagent.Create("agno3", "Silver Nitrate (AgNO3)", "نترات الفضة (AgNO3)",
                new Color(0.85f, 0.85f, 0.9f));

            return Reaction.Create(
                chloride, silverNitrate,
                dripCount: 5,
                resultColor: Color.white,
                descEn: "White curdy precipitate",
                descAr: "راسب أبيض متجبن",
                equation: "Ag⁺ + Cl⁻ → AgCl↓ (white)",
                distractorsEn: new[] { "White curdy precipitate", "Yellow precipitate", "No visible change", "Pale blue precipitate" },
                distractorsAr: new[] { "راسب أبيض متجبن", "راسب أصفر", "لا تغيير ملحوظ", "راسب أزرق فاتح" });
        }

        private static void EnsureEventSystem()
        {
            if (Object.FindFirstObjectByType<EventSystem>() != null) return;
            var go = new GameObject("EventSystem", typeof(EventSystem), typeof(StandaloneInputModule));
            Object.DontDestroyOnLoad(go);
        }

        private static Canvas CreateCanvas()
        {
            var go = new GameObject("SliceCanvas", typeof(Canvas), typeof(CanvasScaler), typeof(GraphicRaycaster));
            var canvas = go.GetComponent<Canvas>();
            canvas.renderMode = RenderMode.ScreenSpaceOverlay;
            var scaler = go.GetComponent<CanvasScaler>();
            scaler.uiScaleMode = CanvasScaler.ScaleMode.ScaleWithScreenSize;
            scaler.referenceResolution = new Vector2(1080, 1920);
            Object.DontDestroyOnLoad(go);
            return canvas;
        }

        private static Image CreateBeaker(Transform parent)
        {
            var go = new GameObject("Beaker", typeof(Image));
            go.transform.SetParent(parent, false);
            var rect = go.GetComponent<RectTransform>();
            rect.anchorMin = new Vector2(0.5f, 0.55f);
            rect.anchorMax = new Vector2(0.5f, 0.55f);
            rect.sizeDelta = new Vector2(400, 500);
            rect.anchoredPosition = Vector2.zero;
            go.GetComponent<Image>().color = Color.white;

            var label = new GameObject("Label", typeof(Text));
            label.transform.SetParent(go.transform, false);
            var labelRect = label.GetComponent<RectTransform>();
            labelRect.anchorMin = new Vector2(0, 1);
            labelRect.anchorMax = new Vector2(1, 1);
            labelRect.pivot = new Vector2(0.5f, 1);
            labelRect.anchoredPosition = new Vector2(0, -20);
            labelRect.sizeDelta = new Vector2(0, 60);
            var text = label.GetComponent<Text>();
            text.font = Resources.GetBuiltinResource<Font>("LegacyRuntime.ttf");
            text.alignment = TextAnchor.MiddleCenter;
            text.color = Color.black;
            text.text = LocalizedStrings.Get("slice.beakerLabel");

            return go.GetComponent<Image>();
        }

        private static Text CreateBannerText(Transform parent, Vector2 anchorMin, Vector2 anchorMax)
        {
            var go = new GameObject("Banner", typeof(Text));
            go.transform.SetParent(parent, false);
            var rect = go.GetComponent<RectTransform>();
            rect.anchorMin = anchorMin;
            rect.anchorMax = anchorMax;
            rect.offsetMin = new Vector2(40, 0);
            rect.offsetMax = new Vector2(-40, 0);
            var text = go.GetComponent<Text>();
            text.font = Resources.GetBuiltinResource<Font>("LegacyRuntime.ttf");
            text.alignment = TextAnchor.MiddleCenter;
            text.color = Color.black;
            text.fontSize = 32;
            return text;
        }

        private static void CreateDropper(Transform parent, Image beaker, Reagent reagent,
            PracticeModeController controller)
        {
            var go = new GameObject("Dropper", typeof(Image), typeof(DropperDragHandler));
            go.transform.SetParent(parent, false);
            var rect = go.GetComponent<RectTransform>();
            rect.anchorMin = new Vector2(0.5f, 0.15f);
            rect.anchorMax = new Vector2(0.5f, 0.15f);
            rect.sizeDelta = new Vector2(120, 160);
            rect.anchoredPosition = Vector2.zero;
            go.GetComponent<Image>().color = reagent.dropperTint;

            var handler = go.GetComponent<DropperDragHandler>();
            handler.beakerTarget = beaker.GetComponent<RectTransform>();
            handler.onDripDelivered = controller.AddDrop;
        }

        private static Button CreateRecordButton(Transform parent)
        {
            var go = new GameObject("RecordButton", typeof(Image), typeof(Button));
            go.transform.SetParent(parent, false);
            var rect = go.GetComponent<RectTransform>();
            rect.anchorMin = new Vector2(0.5f, 0.05f);
            rect.anchorMax = new Vector2(0.5f, 0.05f);
            rect.sizeDelta = new Vector2(400, 90);
            rect.anchoredPosition = Vector2.zero;

            var label = new GameObject("Label", typeof(Text));
            label.transform.SetParent(go.transform, false);
            var labelRect = label.GetComponent<RectTransform>();
            labelRect.anchorMin = Vector2.zero;
            labelRect.anchorMax = Vector2.one;
            labelRect.offsetMin = Vector2.zero;
            labelRect.offsetMax = Vector2.zero;
            var text = label.GetComponent<Text>();
            text.font = Resources.GetBuiltinResource<Font>("LegacyRuntime.ttf");
            text.alignment = TextAnchor.MiddleCenter;
            text.color = Color.black;
            text.text = LocalizedStrings.Get("slice.recordButton");

            var button = go.GetComponent<Button>();
            button.interactable = false; // per law 1: disabled until enough drips have actually been delivered
            return button;
        }

        private static void CreateObservationPanel(Transform parent, PracticeModeController controller,
            Reaction reaction, Text feedbackText)
        {
            var panelGo = new GameObject("ObservationPanel", typeof(Image), typeof(VerticalLayoutGroup));
            panelGo.transform.SetParent(parent, false);
            var rect = panelGo.GetComponent<RectTransform>();
            rect.anchorMin = new Vector2(0.5f, 0.5f);
            rect.anchorMax = new Vector2(0.5f, 0.5f);
            rect.sizeDelta = new Vector2(600, 400);
            rect.anchoredPosition = Vector2.zero;
            panelGo.GetComponent<Image>().color = new Color(0, 0, 0, 0.85f);
            var layout = panelGo.GetComponent<VerticalLayoutGroup>();
            layout.spacing = 12;
            layout.padding = new RectOffset(20, 20, 20, 20);
            layout.childForceExpandHeight = false;

            string[] optionsEn = reaction.distractorDescriptionsEn;
            int correctIndex = System.Array.IndexOf(optionsEn, reaction.resultDescriptionEn);

            for (int i = 0; i < optionsEn.Length; i++)
            {
                int capturedIndex = i;
                var optionGo = new GameObject($"Option{i}", typeof(Image), typeof(Button));
                optionGo.transform.SetParent(panelGo.transform, false);
                optionGo.GetComponent<Image>().color = new Color(1, 1, 1, 0.9f);
                optionGo.GetComponent<RectTransform>().sizeDelta = new Vector2(0, 60);

                var labelGo = new GameObject("Label", typeof(Text));
                labelGo.transform.SetParent(optionGo.transform, false);
                var labelRect = labelGo.GetComponent<RectTransform>();
                labelRect.anchorMin = Vector2.zero;
                labelRect.anchorMax = Vector2.one;
                labelRect.offsetMin = Vector2.zero;
                labelRect.offsetMax = Vector2.zero;
                var labelText = labelGo.GetComponent<Text>();
                labelText.font = Resources.GetBuiltinResource<Font>("LegacyRuntime.ttf");
                labelText.alignment = TextAnchor.MiddleCenter;
                labelText.color = Color.black;
                labelText.text = LocalizedStrings.Current == Language.Arabic
                    ? reaction.distractorDescriptionsAr[capturedIndex]
                    : optionsEn[capturedIndex];

                optionGo.GetComponent<Button>().onClick.AddListener(() =>
                {
                    bool correct = capturedIndex == correctIndex;
                    controller.RecordObservation(correct);
                    feedbackText.text = correct
                        ? $"{LocalizedStrings.Get("slice.correct")} {reaction.equationText}"
                        : LocalizedStrings.Get("slice.incorrect");
                    Object.Destroy(panelGo);
                });
            }
        }
    }
}
