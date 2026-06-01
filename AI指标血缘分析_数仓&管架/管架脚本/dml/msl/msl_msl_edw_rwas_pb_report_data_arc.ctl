-- SQL* Unloader: Fast Oracle TetUnloader (Gzip),Release 3.0.1
-- (@) Copyright Lou Fangxin (AnySQL.net) 2004 -2010, all rigths reserved.
-- Purpose:    Sqlldr Control File
-- Author:     Sunline
-- CreateDate: 20190705
-- FileType:   Control-File
-- Logs:
--     luzd 2019-07-05 create template

options(bindsize=2097152,readsize=2097152,errors=0,rows=5000)
load data
infile '${data_path}/rwas_pb_report_data_arc.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_rwas_pb_report_data_arc
fields terminated by x'1b' 
trailing nullcols
(
    etl_dt date "yyyy-mm-dd hh24:mi:ss" nullif etl_dt=blanks 
    ,data_id char(4000) nullif data_id=blanks 
    ,item_cd char(4000) nullif item_cd=blanks 
    ,item_name char(4000) nullif item_name=blanks 
    ,line_number char(4000) nullif line_number=blanks 
    ,item_a char(4000) nullif item_a=blanks 
    ,item_b char(4000) nullif item_b=blanks 
    ,item_c char(4000) nullif item_c=blanks 
    ,item_d char(4000) nullif item_d=blanks 
    ,item_e char(4000) nullif item_e=blanks 
    ,item_f char(4000) nullif item_f=blanks 
    ,item_g char(4000) nullif item_g=blanks 
    ,item_h char(4000) nullif item_h=blanks 
    ,item_i char(4000) nullif item_i=blanks 
    ,item_j char(4000) nullif item_j=blanks 
    ,item_k char(4000) nullif item_k=blanks 
    ,item_l char(4000) nullif item_l=blanks 
    ,item_m char(4000) nullif item_m=blanks 
    ,item_n char(4000) nullif item_n=blanks 
    ,item_o char(4000) nullif item_o=blanks 
    ,item_p char(4000) nullif item_p=blanks 
    ,item_q char(4000) nullif item_q=blanks 
    ,item_r char(4000) nullif item_r=blanks 
    ,item_s char(4000) nullif item_s=blanks 
    ,item_t char(4000) nullif item_t=blanks 
    ,item_u char(4000) nullif item_u=blanks 
    ,item_v char(4000) nullif item_v=blanks 
    ,item_w char(4000) nullif item_w=blanks 
    ,item_x char(4000) nullif item_x=blanks 
    ,item_y char(4000) nullif item_y=blanks 
    ,item_z char(4000) nullif item_z=blanks 
    ,item_aa char(4000) nullif item_aa=blanks 
    ,item_ab char(4000) nullif item_ab=blanks 
    ,item_ac char(4000) nullif item_ac=blanks 
    ,item_ad char(4000) nullif item_ad=blanks 
    ,item_ae char(4000) nullif item_ae=blanks 
    ,item_af char(4000) nullif item_af=blanks 
    ,load_date char(4000) nullif load_date=blanks 
    ,data_date char(4000) nullif data_date=blanks 
    ,solo_no char(4000) nullif solo_no=blanks 
    ,item_ag char(4000) nullif item_ag=blanks 
    ,item_ah char(4000) nullif item_ah=blanks 
    ,item_ai char(4000) nullif item_ai=blanks 
    ,item_aj char(4000) nullif item_aj=blanks 
    ,item_ak char(4000) nullif item_ak=blanks 
    ,item_al char(4000) nullif item_al=blanks 
    ,item_am char(4000) nullif item_am=blanks 
    ,item_an char(4000) nullif item_an=blanks 
    ,item_ao char(4000) nullif item_ao=blanks 
    ,item_ap char(4000) nullif item_ap=blanks 
    ,item_aq char(4000) nullif item_aq=blanks 
    ,item_ar char(4000) nullif item_ar=blanks 
    ,item_as char(4000) nullif item_as=blanks 
    ,item_at char(4000) nullif item_at=blanks 
    ,item_au char(4000) nullif item_au=blanks 
    ,item_av char(4000) nullif item_av=blanks 
    ,item_aw char(4000) nullif item_aw=blanks 
    ,item_ax char(4000) nullif item_ax=blanks 
    ,item_ay char(4000) nullif item_ay=blanks 
    ,item_az char(4000) nullif item_az=blanks 
    ,item_ba char(4000) nullif item_ba=blanks 
    ,item_bb char(4000) nullif item_bb=blanks 
    ,item_bc char(4000) nullif item_bc=blanks 
    ,item_bd char(4000) nullif item_bd=blanks 
    ,item_be char(4000) nullif item_be=blanks 
    ,item_bf char(4000) nullif item_bf=blanks 
    ,item_bg char(4000) nullif item_bg=blanks 
    ,item_bh char(4000) nullif item_bh=blanks 
    ,item_bi char(4000) nullif item_bi=blanks 
    ,item_bj char(4000) nullif item_bj=blanks 
    ,item_bk char(4000) nullif item_bk=blanks 
    ,item_bl char(4000) nullif item_bl=blanks 
    ,item_bm char(4000) nullif item_bm=blanks 
    ,item_bn char(4000) nullif item_bn=blanks 
    ,item_bo char(4000) nullif item_bo=blanks 
    ,item_bp char(4000) nullif item_bp=blanks 
    ,item_bq char(4000) nullif item_bq=blanks 
    ,item_br char(4000) nullif item_br=blanks 
    ,item_bs char(4000) nullif item_bs=blanks 
    ,item_bt char(4000) nullif item_bt=blanks 
    ,item_bu char(4000) nullif item_bu=blanks 
    ,item_bv char(4000) nullif item_bv=blanks 
    ,item_bw char(4000) nullif item_bw=blanks 
    ,item_bx char(4000) nullif item_bx=blanks 
    ,item_by char(4000) nullif item_by=blanks 
    ,item_bz char(4000) nullif item_bz=blanks 
    ,item_ca char(4000) nullif item_ca=blanks 
    ,item_cb char(4000) nullif item_cb=blanks 
    ,item_cc char(4000) nullif item_cc=blanks 
    ,item_ccd char(4000) nullif item_ccd=blanks 
    ,item_ce char(4000) nullif item_ce=blanks 
    ,item_cf char(4000) nullif item_cf=blanks 
    ,item_cg char(4000) nullif item_cg=blanks 
    ,item_ch char(4000) nullif item_ch=blanks 
    ,item_ci char(4000) nullif item_ci=blanks 
    ,item_cj char(4000) nullif item_cj=blanks 
    ,item_ck char(4000) nullif item_ck=blanks 
    ,item_cl char(4000) nullif item_cl=blanks 
    ,item_cm char(4000) nullif item_cm=blanks 
    ,item_cn char(4000) nullif item_cn=blanks 
    ,item_co char(4000) nullif item_co=blanks 
    ,item_cp char(4000) nullif item_cp=blanks 
    ,item_cq char(4000) nullif item_cq=blanks 
    ,item_cr char(4000) nullif item_cr=blanks 
    ,item_cs char(4000) nullif item_cs=blanks 
    ,item_ct char(4000) nullif item_ct=blanks 
    ,item_cu char(4000) nullif item_cu=blanks 
    ,item_cv char(4000) nullif item_cv=blanks 
    ,item_cw char(4000) nullif item_cw=blanks 
    ,item_cx char(4000) nullif item_cx=blanks 
    ,item_cy char(4000) nullif item_cy=blanks 
    ,item_cz char(4000) nullif item_cz=blanks 
    ,org_cd char(4000) nullif org_cd=blanks 
    ,ccy_cd char(4000) nullif ccy_cd=blanks 
    ,version char(4000) nullif version=blanks 
    ,version_status char(4000) nullif version_status=blanks 
    ,operate_dt char(4000) nullif operate_dt=blanks 
    ,operate_id char(4000) nullif operate_id=blanks 
    ,operate_name char(4000) nullif operate_name=blanks 
    ,flow_starter_id char(4000) nullif flow_starter_id=blanks 
    ,flow_starter_name char(4000) nullif flow_starter_name=blanks 
)