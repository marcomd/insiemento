import{_ as y,h as m,j as x,r as o,o as s,b as i,c as d,w as t,f as N,F as C,d as z,a,e as c,k as B,g as u,t as l}from"./application-60b6312b.js";const V={name:"SectionNews",provide:{theme:{isDark:!0}},mixins:[m,x],computed:{organizationNews(){return this.organizationPublicNews}},methods:{getColor(n,_){return _?n.color:null}}},b={id:"news"},S={class:"text-center"};function j(n,_,D,F,M,r){const h=o("v-icon"),v=o("v-divider"),g=o("v-row"),p=o("v-sheet"),w=o("v-carousel-item"),f=o("v-carousel");return s(),i("section",b,[n.hasOrganizationNews?(s(),d(f,{key:0,cycle:"","show-arrows-on-hover":""},{default:t(()=>[(s(!0),i(C,null,z(r.organizationNews,(e,k)=>(s(),d(w,{key:k},{default:t(()=>[a(p,{color:r.getColor(e,e.dark_style),dark:e.dark_style,light:!e.dark_style,height:"100%"},{default:t(()=>[a(g,{class:"fill-height pa-5",align:"center",justify:"center"},{default:t(()=>[c("div",null,[c("div",{class:"display-2 text-center",style:B(`width: 100%; color: ${r.getColor(e,!e.dark_style)}`)},[u(l(e.title)+" ",1),a(h,{"x-large":"",color:r.getColor(e,!e.dark_style)},{default:t(()=>[u(l(e.icon),1)]),_:2},1032,["color"])],4),a(v),c("div",S,l(e.body),1)])]),_:2},1024)]),_:2},1032,["color","dark","light"])]),_:2},1024))),128))]),_:1})):N("",!0)])}const L=y(V,[["render",j]]);export{L as default};