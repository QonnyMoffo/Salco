exec jsyb_fnd_funciones.JSYB_FND_SET_EMPRESA( 1 );




--
--  SUCURSAL, SALIDA y BANDEJAS
--

select  * from SU_SUCURSAL
where   su_suc_id = 31;

select  *
from    SALIDAS_ENC_TL
where   numero = 131615;

select  a.estado, a.bdg_codigo, a.*
from    SALIDAS_DET_TL a
where   numero = 131615
and     lo_codigo = 31;

select  b.bdg_codigo, b.codigo_bandeja_pub, b.estado, b.ind_revision_rcm, b.*
from    BANDEJAS b
where   b.numero = 131615
and     b.lo_codigo =  31;

--  Costo Bandejas
select  b.bdg_codigo, b.codigo_bandeja_pub, b.estado, b.ind_revision_rcm, b.codigo_bandeja, count(*), sum( round( bodega_pkg_01.get_pmp( 228,  d.inventory_item_id ), 0 ) ) costo_ban
from    BANDEJAS b, DETALLE_X_BANDEJAS d
where   b.numero = 131615
and     b.lo_codigo =  31
and     d.codigo_bandeja = b.codigo_bandeja
group by b.bdg_codigo, b.codigo_bandeja_pub, b.estado, b.ind_revision_rcm, b.codigo_bandeja;

select  round( bodega_pkg_01.get_pmp( 228,  d.inventory_item_id ), 0 ) costo_prod, d.*
from    DETALLE_X_BANDEJAS d
where   codigo_bandeja in (
            select  b.codigo_bandeja
            from    bandejas b
            where   numero = 131615
            and     lo_codigo = 31
        )
order by codigo_bandeja;

select  *
from    DETALLE_BANDEJAS_X_LOTE
where   codigo_bandeja in (
            select  b.codigo_bandeja
            from    bandejas b
            where   numero = 131615
            and     lo_codigo = 31
        )
order by codigo_bandeja;

select  *
from    DIFERENCIAS_ITEM_RECEPCION
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
from    JSYB_RCM_SALIDAS_PROC
where   numero_salida = 131615
and     lo_codigo = 31;

select  *
from    JSYB_RCM_BANDEJAS
where   numero_salida = 131615
and     lo_codigo = 31;

select  *
from    JSYB_RCM_REVISIONES_CONTENIDO
where   numero_salida = 131615
and     lo_codigo = 31;

select  *
from    JSYB_RCM_DETALLE_REVISION
where   numero_salida = 131615
and     lo_codigo = 31;

--
--  TRENCITO
--

select  *
from    JSYB_BG_MOVS_BANDEJA
where   codigo_bandeja in (
            select  b.codigo_bandeja
            from    bandejas b
            where   numero = 131615
            and     lo_codigo = 31
        );

select  *
from    JSYB_BG_TRANSACC_INVENTARIO
--where   source_header_id = 777768848624
where     transaction_date > sysdate - 3/(24*60);

--
--  VALE
--

select  *
from    JSYB_BG_VALE_RECEPCION_SALIDA
where   numero_salida = 131615
and     lo_codigo = 31;

select  *
from    JSYB_BG_BULTOS_VALE_RECEP
where   numero_vale_recep in (
            select  v.numero_vale_recep
            from    JSYB_BG_VALE_RECEPCION_SALIDA v
            where   numero_salida = 131615
            and     lo_codigo = 31
        );

select  *
from    JSYB_BG_OTR_BOD_VALE_RECEP
where   numero_salida = 131615
and     lo_codigo =  31;

select  t1.barcode_number, t1.barcode_qty, t1.barcode_type, t3.codigo_bandeja_pub, t2.*
from    SYB_ITEM_BARCODES t1, DETALLE_X_BANDEJAS t2, JSYB_RCM_BANDEJAS t3
where   t3.numero_salida = 131615
    and t3.lo_codigo = 31
    and t3.estado in ( 'PREV', 'ERC', 'REV' )
    and t1.organization_id = 228
    and t1.barcode_item_id = t2.inventory_item_id
    and t3.codigo_bandeja = t2.codigo_bandeja;
