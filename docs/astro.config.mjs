// @ts-check
import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';

import d2 from 'astro-d2';

// https://astro.build/config
export default defineConfig({
  integrations: [starlight({
    title: 'infra.paultibbetts.uk',
    social: [{ icon: 'github', label: 'GitHub', href: 'https://github.com/paultibbetts/infra.paultibbetts.uk' }],
    sidebar: [
      { label: 'Index', link: '/' },
      {
        label: 'Architecture',
        items: [
          { label: 'Overview', slug: 'architecture/overview' },
          { label: 'Network', slug: 'architecture/network' },
          { label: 'Hardware', slug: 'architecture/hardware' },
          { label: 'Software', slug: 'architecture/software' },
        ],
      },
      {
        label: 'Automation',
        items: [
          { label: 'Overview', slug: 'automation/overview' },
          { label: 'Terraform', slug: 'automation/terraform' },
          { label: 'Ansible', slug: 'automation/ansible' },
          { label: 'CD', link: 'automation/cd' },
          { label: 'Workflow', link: 'automation/workflow' },
        ],
      },
      {
        label: 'Decisions',
        autogenerate: { directory: 'decisions' },
      },
      { label: 'Code', link: '/code' },

    ],
  }), d2({
    sketch: true,
    experimental: {
      useD2js: true,
    },
  })],
});
