<script lang="ts">
  import { useMasonry } from "$lib/masonry";
  import { onMount } from "svelte";

  let gridEl: HTMLElement;

  const images = Object.entries(
    import.meta.glob("$lib/images/*.{png,jpg,jpeg,webp,gif}", {
      eager: true,
      as: "url",
    }),
  )
    .sort(([a], [b]) => a.localeCompare(b))
    .map(([, url]) => url);

  onMount(() => {
    useMasonry(gridEl);
    window.addEventListener("resize", () => useMasonry(gridEl));
    window.addEventListener("reload:masonry", () => useMasonry(gridEl));
  });

  $: {
    if (gridEl) {
      useMasonry(gridEl);
    }
  }
</script>

<svelte:head>
  <title>VSCO</title>
</svelte:head>

<ul
  bind:this={gridEl}
  class="grid sm:grid-cols-2 lg:grid-cols-3 gap-4 m-4"
  style="align-items: flex-start;"
>
  {#each images as img}
    <li>
      <img
        src={img}
        alt="Gallery"
        class="w-full rounded shadow-md object-cover"
        loading="lazy"
      />
    </li>
  {/each}
</ul>
