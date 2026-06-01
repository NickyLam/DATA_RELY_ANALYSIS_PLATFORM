: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rwas_pb_report_data_arc_f
CreateDate: 20240929
FileName:   ${iel_data_path}/rwas_pb_report_data_arc.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.data_id,chr(13),''),chr(10),'') as data_id
,replace(replace(t1.item_cd,chr(13),''),chr(10),'') as item_cd
,replace(replace(t1.item_name,chr(13),''),chr(10),'') as item_name
,line_number
,replace(replace(t1.item_a,chr(13),''),chr(10),'') as item_a
,replace(replace(t1.item_b,chr(13),''),chr(10),'') as item_b
,replace(replace(t1.item_c,chr(13),''),chr(10),'') as item_c
,replace(replace(t1.item_d,chr(13),''),chr(10),'') as item_d
,replace(replace(t1.item_e,chr(13),''),chr(10),'') as item_e
,replace(replace(t1.item_f,chr(13),''),chr(10),'') as item_f
,replace(replace(t1.item_g,chr(13),''),chr(10),'') as item_g
,replace(replace(t1.item_h,chr(13),''),chr(10),'') as item_h
,replace(replace(t1.item_i,chr(13),''),chr(10),'') as item_i
,replace(replace(t1.item_j,chr(13),''),chr(10),'') as item_j
,replace(replace(t1.item_k,chr(13),''),chr(10),'') as item_k
,replace(replace(t1.item_l,chr(13),''),chr(10),'') as item_l
,replace(replace(t1.item_m,chr(13),''),chr(10),'') as item_m
,replace(replace(t1.item_n,chr(13),''),chr(10),'') as item_n
,replace(replace(t1.item_o,chr(13),''),chr(10),'') as item_o
,replace(replace(t1.item_p,chr(13),''),chr(10),'') as item_p
,replace(replace(t1.item_q,chr(13),''),chr(10),'') as item_q
,replace(replace(t1.item_r,chr(13),''),chr(10),'') as item_r
,replace(replace(t1.item_s,chr(13),''),chr(10),'') as item_s
,replace(replace(t1.item_t,chr(13),''),chr(10),'') as item_t
,replace(replace(t1.item_u,chr(13),''),chr(10),'') as item_u
,replace(replace(t1.item_v,chr(13),''),chr(10),'') as item_v
,replace(replace(t1.item_w,chr(13),''),chr(10),'') as item_w
,replace(replace(t1.item_x,chr(13),''),chr(10),'') as item_x
,replace(replace(t1.item_y,chr(13),''),chr(10),'') as item_y
,replace(replace(t1.item_z,chr(13),''),chr(10),'') as item_z
,replace(replace(t1.item_aa,chr(13),''),chr(10),'') as item_aa
,replace(replace(t1.item_ab,chr(13),''),chr(10),'') as item_ab
,replace(replace(t1.item_ac,chr(13),''),chr(10),'') as item_ac
,replace(replace(t1.item_ad,chr(13),''),chr(10),'') as item_ad
,replace(replace(t1.item_ae,chr(13),''),chr(10),'') as item_ae
,replace(replace(t1.item_af,chr(13),''),chr(10),'') as item_af
,replace(replace(t1.load_date,chr(13),''),chr(10),'') as load_date
,replace(replace(t1.data_date,chr(13),''),chr(10),'') as data_date
,replace(replace(t1.solo_no,chr(13),''),chr(10),'') as solo_no
,replace(replace(t1.item_ag,chr(13),''),chr(10),'') as item_ag
,replace(replace(t1.item_ah,chr(13),''),chr(10),'') as item_ah
,replace(replace(t1.item_ai,chr(13),''),chr(10),'') as item_ai
,replace(replace(t1.item_aj,chr(13),''),chr(10),'') as item_aj
,replace(replace(t1.item_ak,chr(13),''),chr(10),'') as item_ak
,replace(replace(t1.item_al,chr(13),''),chr(10),'') as item_al
,replace(replace(t1.item_am,chr(13),''),chr(10),'') as item_am
,replace(replace(t1.item_an,chr(13),''),chr(10),'') as item_an
,replace(replace(t1.item_ao,chr(13),''),chr(10),'') as item_ao
,replace(replace(t1.item_ap,chr(13),''),chr(10),'') as item_ap
,replace(replace(t1.item_aq,chr(13),''),chr(10),'') as item_aq
,replace(replace(t1.item_ar,chr(13),''),chr(10),'') as item_ar
,replace(replace(t1.item_as,chr(13),''),chr(10),'') as item_as
,replace(replace(t1.item_at,chr(13),''),chr(10),'') as item_at
,replace(replace(t1.item_au,chr(13),''),chr(10),'') as item_au
,replace(replace(t1.item_av,chr(13),''),chr(10),'') as item_av
,replace(replace(t1.item_aw,chr(13),''),chr(10),'') as item_aw
,replace(replace(t1.item_ax,chr(13),''),chr(10),'') as item_ax
,replace(replace(t1.item_ay,chr(13),''),chr(10),'') as item_ay
,replace(replace(t1.item_az,chr(13),''),chr(10),'') as item_az
,replace(replace(t1.item_ba,chr(13),''),chr(10),'') as item_ba
,replace(replace(t1.item_bb,chr(13),''),chr(10),'') as item_bb
,replace(replace(t1.item_bc,chr(13),''),chr(10),'') as item_bc
,replace(replace(t1.item_bd,chr(13),''),chr(10),'') as item_bd
,replace(replace(t1.item_be,chr(13),''),chr(10),'') as item_be
,replace(replace(t1.item_bf,chr(13),''),chr(10),'') as item_bf
,replace(replace(t1.item_bg,chr(13),''),chr(10),'') as item_bg
,replace(replace(t1.item_bh,chr(13),''),chr(10),'') as item_bh
,replace(replace(t1.item_bi,chr(13),''),chr(10),'') as item_bi
,replace(replace(t1.item_bj,chr(13),''),chr(10),'') as item_bj
,replace(replace(t1.item_bk,chr(13),''),chr(10),'') as item_bk
,replace(replace(t1.item_bl,chr(13),''),chr(10),'') as item_bl
,replace(replace(t1.item_bm,chr(13),''),chr(10),'') as item_bm
,replace(replace(t1.item_bn,chr(13),''),chr(10),'') as item_bn
,replace(replace(t1.item_bo,chr(13),''),chr(10),'') as item_bo
,replace(replace(t1.item_bp,chr(13),''),chr(10),'') as item_bp
,replace(replace(t1.item_bq,chr(13),''),chr(10),'') as item_bq
,replace(replace(t1.item_br,chr(13),''),chr(10),'') as item_br
,replace(replace(t1.item_bs,chr(13),''),chr(10),'') as item_bs
,replace(replace(t1.item_bt,chr(13),''),chr(10),'') as item_bt
,replace(replace(t1.item_bu,chr(13),''),chr(10),'') as item_bu
,replace(replace(t1.item_bv,chr(13),''),chr(10),'') as item_bv
,replace(replace(t1.item_bw,chr(13),''),chr(10),'') as item_bw
,replace(replace(t1.item_bx,chr(13),''),chr(10),'') as item_bx
,replace(replace(t1.item_by,chr(13),''),chr(10),'') as item_by
,replace(replace(t1.item_bz,chr(13),''),chr(10),'') as item_bz
,replace(replace(t1.item_ca,chr(13),''),chr(10),'') as item_ca
,replace(replace(t1.item_cb,chr(13),''),chr(10),'') as item_cb
,replace(replace(t1.item_cc,chr(13),''),chr(10),'') as item_cc
,replace(replace(t1.item_ccd,chr(13),''),chr(10),'') as item_ccd
,replace(replace(t1.item_ce,chr(13),''),chr(10),'') as item_ce
,replace(replace(t1.item_cf,chr(13),''),chr(10),'') as item_cf
,replace(replace(t1.item_cg,chr(13),''),chr(10),'') as item_cg
,replace(replace(t1.item_ch,chr(13),''),chr(10),'') as item_ch
,replace(replace(t1.item_ci,chr(13),''),chr(10),'') as item_ci
,replace(replace(t1.item_cj,chr(13),''),chr(10),'') as item_cj
,replace(replace(t1.item_ck,chr(13),''),chr(10),'') as item_ck
,replace(replace(t1.item_cl,chr(13),''),chr(10),'') as item_cl
,replace(replace(t1.item_cm,chr(13),''),chr(10),'') as item_cm
,replace(replace(t1.item_cn,chr(13),''),chr(10),'') as item_cn
,replace(replace(t1.item_co,chr(13),''),chr(10),'') as item_co
,replace(replace(t1.item_cp,chr(13),''),chr(10),'') as item_cp
,replace(replace(t1.item_cq,chr(13),''),chr(10),'') as item_cq
,replace(replace(t1.item_cr,chr(13),''),chr(10),'') as item_cr
,replace(replace(t1.item_cs,chr(13),''),chr(10),'') as item_cs
,replace(replace(t1.item_ct,chr(13),''),chr(10),'') as item_ct
,replace(replace(t1.item_cu,chr(13),''),chr(10),'') as item_cu
,replace(replace(t1.item_cv,chr(13),''),chr(10),'') as item_cv
,replace(replace(t1.item_cw,chr(13),''),chr(10),'') as item_cw
,replace(replace(t1.item_cx,chr(13),''),chr(10),'') as item_cx
,replace(replace(t1.item_cy,chr(13),''),chr(10),'') as item_cy
,replace(replace(t1.item_cz,chr(13),''),chr(10),'') as item_cz
,replace(replace(t1.org_cd,chr(13),''),chr(10),'') as org_cd
,replace(replace(t1.ccy_cd,chr(13),''),chr(10),'') as ccy_cd
,replace(replace(t1.version,chr(13),''),chr(10),'') as version
,version_status
,replace(replace(t1.operate_dt,chr(13),''),chr(10),'') as operate_dt
,replace(replace(t1.operate_id,chr(13),''),chr(10),'') as operate_id
,replace(replace(t1.operate_name,chr(13),''),chr(10),'') as operate_name
,replace(replace(t1.flow_starter_id,chr(13),''),chr(10),'') as flow_starter_id
,replace(replace(t1.flow_starter_name,chr(13),''),chr(10),'') as flow_starter_name

from ${iol_schema}.rwas_pb_report_data_arc t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rwas_pb_report_data_arc.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
