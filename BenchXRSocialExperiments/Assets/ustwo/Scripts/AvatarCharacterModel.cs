using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Normal.Realtime;
using Normal.Realtime.Serialization;

[RealtimeModel]
public partial class AvatarCharacterModel
{
    [RealtimeProperty(1, true, true)]
    private int _characterModelIndex;
    [RealtimeProperty(2, true, true)]
    private int _characterMaterialIndex;
}

/* ----- Begin Normal Autogenerated Code ----- */
public partial class AvatarCharacterModel : RealtimeModel {
    public int characterModelIndex {
        get {
            return _characterModelIndexProperty.value;
        }
        set {
            if (_characterModelIndexProperty.value == value) return;
            _characterModelIndexProperty.value = value;
            InvalidateReliableLength();
            FireCharacterModelIndexDidChange(value);
        }
    }
    
    public int characterMaterialIndex {
        get {
            return _characterMaterialIndexProperty.value;
        }
        set {
            if (_characterMaterialIndexProperty.value == value) return;
            _characterMaterialIndexProperty.value = value;
            InvalidateReliableLength();
            FireCharacterMaterialIndexDidChange(value);
        }
    }
    
    public delegate void PropertyChangedHandler<in T>(AvatarCharacterModel model, T value);
    public event PropertyChangedHandler<int> characterModelIndexDidChange;
    public event PropertyChangedHandler<int> characterMaterialIndexDidChange;
    
    public enum PropertyID : uint {
        CharacterModelIndex = 1,
        CharacterMaterialIndex = 2,
    }
    
    #region Properties
    
    private ReliableProperty<int> _characterModelIndexProperty;
    
    private ReliableProperty<int> _characterMaterialIndexProperty;
    
    #endregion
    
    public AvatarCharacterModel() : base(null) {
        _characterModelIndexProperty = new ReliableProperty<int>(1, _characterModelIndex);
        _characterMaterialIndexProperty = new ReliableProperty<int>(2, _characterMaterialIndex);
    }
    
    protected override void OnParentReplaced(RealtimeModel previousParent, RealtimeModel currentParent) {
        _characterModelIndexProperty.UnsubscribeCallback();
        _characterMaterialIndexProperty.UnsubscribeCallback();
    }
    
    private void FireCharacterModelIndexDidChange(int value) {
        try {
            characterModelIndexDidChange?.Invoke(this, value);
        } catch (System.Exception exception) {
            UnityEngine.Debug.LogException(exception);
        }
    }
    
    private void FireCharacterMaterialIndexDidChange(int value) {
        try {
            characterMaterialIndexDidChange?.Invoke(this, value);
        } catch (System.Exception exception) {
            UnityEngine.Debug.LogException(exception);
        }
    }
    
    protected override int WriteLength(StreamContext context) {
        var length = 0;
        length += _characterModelIndexProperty.WriteLength(context);
        length += _characterMaterialIndexProperty.WriteLength(context);
        return length;
    }
    
    protected override void Write(WriteStream stream, StreamContext context) {
        var writes = false;
        writes |= _characterModelIndexProperty.Write(stream, context);
        writes |= _characterMaterialIndexProperty.Write(stream, context);
        if (writes) InvalidateContextLength(context);
    }
    
    protected override void Read(ReadStream stream, StreamContext context) {
        var anyPropertiesChanged = false;
        while (stream.ReadNextPropertyID(out uint propertyID)) {
            var changed = false;
            switch (propertyID) {
                case (uint) PropertyID.CharacterModelIndex: {
                    changed = _characterModelIndexProperty.Read(stream, context);
                    if (changed) FireCharacterModelIndexDidChange(characterModelIndex);
                    break;
                }
                case (uint) PropertyID.CharacterMaterialIndex: {
                    changed = _characterMaterialIndexProperty.Read(stream, context);
                    if (changed) FireCharacterMaterialIndexDidChange(characterMaterialIndex);
                    break;
                }
                default: {
                    stream.SkipProperty();
                    break;
                }
            }
            anyPropertiesChanged |= changed;
        }
        if (anyPropertiesChanged) {
            UpdateBackingFields();
        }
    }
    
    private void UpdateBackingFields() {
        _characterModelIndex = characterModelIndex;
        _characterMaterialIndex = characterMaterialIndex;
    }
    
}
/* ----- End Normal Autogenerated Code ----- */
