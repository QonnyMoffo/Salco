exec jsyb_fnd_funciones.JSYB_FND_SET_EMPRESA( 1 );




--
--  SUCURSAL, SALIDA y BANDEJAS
--

select  * from su_sucursal
where   su_suc_id = 31;

select  *
from    salidas_enc_tl
where   numero = 131615;

select  a.estado, a.bdg_codigo, a.*
from    salidas_det_tl a
where   numero = 131615
and     lo_codigo = 31;

select  b.bdg_codigo, b.codigo_bandeja_pub, b.estado, b.IND_REVISION_RCM, b.*
from    bandejas b
where   b.numero = 131615
and     b.lo_codigo = 31;

--  Costo Bandejas
select  b.bdg_codigo, b.codigo_bandeja_pub, b.estado, b.IND_REVISION_RCM, b.codigo_bandeja, count(*), sum( round( bodega_pkg_01.get_pmp( 228,  d.inventory_item_id ), 0 ) ) costo_ban
from    bandejas b,
        detalle_x_bandejas d
where   b.numero = 131615
and     b.lo_codigo = 31
and     d.codigo_bandeja = b.codigo_bandeja
group by b.bdg_codigo, b.codigo_bandeja_pub, b.estado, b.IND_REVISION_RCM, b.codigo_bandeja;

select  round( bodega_pkg_01.get_pmp( 228,  d.inventory_item_id ), 0 ) costo_prod, d.*
from    detalle_x_bandejas d
where   codigo_bandeja in (
            select  b.codigo_bandeja
            from    bandejas b
            where   numero = 131615
            and     lo_codigo = 31
        )
order by codigo_bandeja;

select  *
from    detalle_bandejas_x_lote
where   codigo_bandeja in (
            select  b.codigo_bandeja
            from    bandejas b
            where   numero = 131615
            and     lo_codigo = 31
        )
order by codigo_bandeja;

select  *
from    diferencias_item_recepcion
where   ba_codigo_bandeja in (
            select  b.codigo_bandeja
            from    bandejas b
            where   numero = 131615
            and     lo_codigo = 31
        );

--
--  RECEPCION CIEGA MOBILE
--

select  *
from    jsyb_rcm_salidas_proc
where   numero_salida = 131615
and     lo_codigo = 31;

select  *
from    jsyb_rcm_bandejas
where   numero_salida = 131615
and     lo_codigo = 31;

select  *
from    jsyb_rcm_revisiones_contenido
where   numero_salida = 131615
and     lo_codigo = 31;

select  *
from    jsyb_rcm_detalle_revision
where   numero_salida = 131615
and     lo_codigo = 31;

--
--  TRENCITO
--

select  *
from    jsyb_bg_movs_bandeja
where   codigo_bandeja in (
            select  b.codigo_bandeja
            from    bandejas b
            where   numero = 131615
            and     lo_codigo = 31
        );

select  *
from    jsyb_bg_transacc_inventario
--where   source_header_id = 777768848624
where     transaction_date > sysdate - 3/(24*60);

--
--  VALE
--

select  *
from    jsyb_bg_vale_recepcion_salida
where   numero_salida = 131615
and     lo_codigo = 31;

select  *
from    jsyb_bg_bultos_vale_recep
where   NUMERO_VALE_RECEP in (
            select  v.NUMERO_VALE_RECEP
            from    jsyb_bg_vale_recepcion_salida v
            where   numero_salida = 131615
            and     lo_codigo = 31
        );

select  *
from    jsyb_bg_otr_bod_vale_recep
where   numero_salida = 131615
and     lo_codigo = 31;

select  t1.barcode_number, t1.barcode_qty, t1.barcode_type, t3.codigo_bandeja_pub, t2.*
from    syb_item_barcodes t1, detalle_x_bandejas t2, jsyb_rcm_bandejas t3
where   t3.numero_salida = 131615
    and t3.lo_codigo = 31
    and t3.estado in ( 'PREV', 'ERC', 'REV' )
    and t1.organization_id = 228
    and t1.barcode_item_id = t2.inventory_item_id
    and t3.codigo_bandeja = t2.codigo_bandeja;
