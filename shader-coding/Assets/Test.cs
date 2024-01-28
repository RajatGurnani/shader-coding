using System.Collections;
using UnityEngine;

public class Test : MonoBehaviour
{
    public MeshRenderer meshRenderer;
    public Shader shader;
    MaterialPropertyBlock block;

    public void Start()
    {
        meshRenderer = GetComponent<MeshRenderer>();
        block = new();
        StartCoroutine(DoRandom());
    }

    IEnumerator DoRandom()
    {
        while (true)
        {
            meshRenderer.GetPropertyBlock(block);
            block.SetColor("_ColorA", RandomColor());
            block.SetColor("_ColorB", RandomColor());
            meshRenderer.SetPropertyBlock(block);
            yield return new WaitForSeconds(5f);
        }
    }

    public Color RandomColor()
    {
        return new Color(Random.Range(0f, 1f), Random.Range(0f, 1f), Random.Range(0f, 1f), 1.0f);
    }
}
