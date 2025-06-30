<script lang="ts">
  import * as Dialog from "$lib/components/ui/dialog/index.js";
  import { useMasonry } from "$lib/masonry";
  import { onMount } from "svelte";

  let gridEl: HTMLElement;
  let selectedImage: { url: string; alt: string } | null = null;
  let dialogOpen = false;

  const images = Object.entries(
    import.meta.glob("$lib/images/*.{png,jpg,jpeg,webp,gif}", {
      eager: true,
      as: "url",
    }),
  )
    .sort(([a], [b]) => a.localeCompare(b))
    .map(([path, url]) => {
      const match = path.match(/\/([^/]+)\.(png|jpe?g|webp|gif)$/i);
      const alt = match ? match[1].replace(/[-_]/g, " ") : "Gallery image";
      return { url, alt };
    });

  function openDialog(img: { url: string; alt: string }) {
    selectedImage = img;
    dialogOpen = true;
  }

  function closeDialog() {
    dialogOpen = false;
    selectedImage = null;
  }

  onMount(() => {
    useMasonry(gridEl);
    window.addEventListener("resize", () => useMasonry(gridEl));
    window.addEventListener("reload:masonry", () => useMasonry(gridEl));
  });

  $: if (gridEl) {
    useMasonry(gridEl);
  }
</script>

<ul
  bind:this={gridEl}
  class="grid sm:grid-cols-2 lg:grid-cols-3 gap-4 m-4 items-start"
>
  {#each images as img}
    <li on:click={() => openDialog(img)}>
      <img
        src={img.url}
        alt={img.alt}
        class="w-full rounded object-cover cursor-pointer hover:opacity-90 transition-opacity"
        loading="lazy"
      />
    </li>
  {/each}
</ul>

<Dialog.Root bind:open={dialogOpen} onOpenChange={closeDialog}>
  {#if selectedImage}
    <Dialog.Content
      showCloseButton={false}
      class="sm:max-w-[90vw] max-w-[95vw] bg-transparent border-none shadow-none mx-auto w-auto"
    >
      <div class="flex justify-center">
        <img
          src={selectedImage.url}
          alt={selectedImage.alt}
          class="max-h-[95vh] max-w-[95vw] w-auto h-auto object-contain rounded"
          style="aspect-ratio: attr(width) / attr(height);"
        />
      </div>
    </Dialog.Content>
  {/if}
</Dialog.Root>
