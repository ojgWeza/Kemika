using System;
using System.Collections.Generic;
using UnityEngine;
using Kemika.Data;

namespace Kemika.Modes
{
    // Owns the manual interaction loop for one Reaction: drip -> gradual reveal -> record.
    // No chemical result is ever exposed to the player except as the direct output of
    // AddDrop() or RecordObservation() below -- both only ever fire in response to a
    // manual player action (see CONSTITUTION.md, law 1: "No result without action").
    public class PracticeModeController
    {
        public readonly struct AttemptRecord
        {
            public readonly int attemptNumber;
            public readonly bool correct;
            public readonly int dropsUsed;

            public AttemptRecord(int attemptNumber, bool correct, int dropsUsed)
            {
                this.attemptNumber = attemptNumber;
                this.correct = correct;
                this.dropsUsed = dropsUsed;
            }
        }

        public event Action<float> OnProgressChanged; // 0..1, drives the gradual color reveal
        public event Action OnReadyToRecord;
        public event Action<AttemptRecord> OnAttemptRecorded;

        private readonly Reaction _reaction;
        private readonly List<AttemptRecord> _attempts = new();
        private int _dropCount;
        private bool _readyToRecord;

        public PracticeModeController(Reaction reaction)
        {
            _reaction = reaction;
        }

        public IReadOnlyList<AttemptRecord> Attempts => _attempts;

        public void AddDrop()
        {
            if (_readyToRecord) return;

            _dropCount++;
            float progress = Mathf.Clamp01((float)_dropCount / _reaction.requiredDripCount);
            OnProgressChanged?.Invoke(progress);

            if (_dropCount >= _reaction.requiredDripCount)
            {
                _readyToRecord = true;
                OnReadyToRecord?.Invoke();
            }
        }

        public bool RecordObservation(bool isCorrectChoice)
        {
            if (!_readyToRecord) return false;

            var record = new AttemptRecord(_attempts.Count + 1, isCorrectChoice, _dropCount);
            _attempts.Add(record);
            OnAttemptRecorded?.Invoke(record);
            return isCorrectChoice;
        }
    }
}
