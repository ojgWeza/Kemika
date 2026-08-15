using UnityEngine;
using UnityEngine.EventSystems;

namespace Kemika.Interaction
{
    // Drag a reagent dropper icon; each release over the target beaker counts as exactly
    // one manual "drip" action. This is the only path by which PracticeModeController's
    // drip callback is ever invoked -- see CONSTITUTION.md, law 1 ("No result without
    // action"). Hovering, holding, or waiting must never advance the reaction by itself.
    [RequireComponent(typeof(RectTransform))]
    public class DropperDragHandler : MonoBehaviour, IBeginDragHandler, IDragHandler, IEndDragHandler
    {
        public RectTransform beakerTarget;
        public System.Action onDripDelivered;

        private RectTransform _rect;
        private Vector2 _homePosition;
        private Canvas _canvas;

        private void Awake()
        {
            _rect = GetComponent<RectTransform>();
            _canvas = GetComponentInParent<Canvas>();
            _homePosition = _rect.anchoredPosition;
        }

        public void OnBeginDrag(PointerEventData eventData)
        {
        }

        public void OnDrag(PointerEventData eventData)
        {
            _rect.anchoredPosition += eventData.delta / _canvas.scaleFactor;
        }

        public void OnEndDrag(PointerEventData eventData)
        {
            if (beakerTarget != null && RectTransformUtility.RectangleContainsScreenPoint(
                    beakerTarget, eventData.position, eventData.pressEventCamera))
            {
                onDripDelivered?.Invoke();
            }

            _rect.anchoredPosition = _homePosition;
        }
    }
}
