/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_edw_rwas_pb_report_data_arc
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_rwas_pb_report_data_arc
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_rwas_pb_report_data_arc purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_rwas_pb_report_data_arc(
    etl_dt date
    ,data_id varchar2(765)
    ,item_cd varchar2(90)
    ,item_name varchar2(150)
    ,line_number number(38)
    ,item_a varchar2(1500)
    ,item_b varchar2(4000)
    ,item_c varchar2(4000)
    ,item_d varchar2(300)
    ,item_e varchar2(300)
    ,item_f varchar2(300)
    ,item_g varchar2(300)
    ,item_h varchar2(300)
    ,item_i varchar2(300)
    ,item_j varchar2(300)
    ,item_k varchar2(300)
    ,item_l varchar2(300)
    ,item_m varchar2(300)
    ,item_n varchar2(300)
    ,item_o varchar2(300)
    ,item_p varchar2(300)
    ,item_q varchar2(300)
    ,item_r varchar2(300)
    ,item_s varchar2(300)
    ,item_t varchar2(300)
    ,item_u varchar2(300)
    ,item_v varchar2(300)
    ,item_w varchar2(300)
    ,item_x varchar2(300)
    ,item_y varchar2(300)
    ,item_z varchar2(300)
    ,item_aa varchar2(300)
    ,item_ab varchar2(300)
    ,item_ac varchar2(300)
    ,item_ad varchar2(300)
    ,item_ae varchar2(300)
    ,item_af varchar2(300)
    ,load_date varchar2(60)
    ,data_date varchar2(30)
    ,solo_no varchar2(60)
    ,item_ag varchar2(300)
    ,item_ah varchar2(300)
    ,item_ai varchar2(300)
    ,item_aj varchar2(300)
    ,item_ak varchar2(300)
    ,item_al varchar2(300)
    ,item_am varchar2(300)
    ,item_an varchar2(300)
    ,item_ao varchar2(300)
    ,item_ap varchar2(300)
    ,item_aq varchar2(300)
    ,item_ar varchar2(300)
    ,item_as varchar2(300)
    ,item_at varchar2(300)
    ,item_au varchar2(300)
    ,item_av varchar2(300)
    ,item_aw varchar2(300)
    ,item_ax varchar2(300)
    ,item_ay varchar2(300)
    ,item_az varchar2(300)
    ,item_ba varchar2(300)
    ,item_bb varchar2(300)
    ,item_bc varchar2(300)
    ,item_bd varchar2(300)
    ,item_be varchar2(300)
    ,item_bf varchar2(300)
    ,item_bg varchar2(300)
    ,item_bh varchar2(300)
    ,item_bi varchar2(300)
    ,item_bj varchar2(300)
    ,item_bk varchar2(300)
    ,item_bl varchar2(300)
    ,item_bm varchar2(300)
    ,item_bn varchar2(300)
    ,item_bo varchar2(300)
    ,item_bp varchar2(300)
    ,item_bq varchar2(300)
    ,item_br varchar2(300)
    ,item_bs varchar2(300)
    ,item_bt varchar2(300)
    ,item_bu varchar2(300)
    ,item_bv varchar2(300)
    ,item_bw varchar2(300)
    ,item_bx varchar2(300)
    ,item_by varchar2(300)
    ,item_bz varchar2(300)
    ,item_ca varchar2(300)
    ,item_cb varchar2(300)
    ,item_cc varchar2(300)
    ,item_ccd varchar2(300)
    ,item_ce varchar2(300)
    ,item_cf varchar2(300)
    ,item_cg varchar2(300)
    ,item_ch varchar2(300)
    ,item_ci varchar2(300)
    ,item_cj varchar2(300)
    ,item_ck varchar2(300)
    ,item_cl varchar2(300)
    ,item_cm varchar2(300)
    ,item_cn varchar2(300)
    ,item_co varchar2(300)
    ,item_cp varchar2(300)
    ,item_cq varchar2(300)
    ,item_cr varchar2(300)
    ,item_cs varchar2(300)
    ,item_ct varchar2(300)
    ,item_cu varchar2(300)
    ,item_cv varchar2(300)
    ,item_cw varchar2(300)
    ,item_cx varchar2(300)
    ,item_cy varchar2(300)
    ,item_cz varchar2(300)
    ,org_cd varchar2(60)
    ,ccy_cd varchar2(60)
    ,version varchar2(150)
    ,version_status number(22)
    ,operate_dt varchar2(75)
    ,operate_id varchar2(75)
    ,operate_name varchar2(383)
    ,flow_starter_id varchar2(75)
    ,flow_starter_name varchar2(383)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_rwas_pb_report_data_arc to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_rwas_pb_report_data_arc is '公共报表数据表-归档数据';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.etl_dt is '数据日期';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.data_id is '主键id';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_cd is '报表编码';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_name is '报表名称';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.line_number is '行号';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_a is 'a列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_b is 'b列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_c is 'c列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_d is 'd列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_e is 'e列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_f is 'f列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_g is 'g列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_h is 'h列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_i is 'i列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_j is 'j列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_k is 'k列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_l is 'l列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_m is 'm列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_n is 'n列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_o is 'o列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_p is 'p列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_q is 'q列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_r is 'r列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_s is 's列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_t is 't列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_u is 'u列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_v is 'v列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_w is 'w列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_x is 'x列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_y is 'y列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_z is 'z列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_aa is 'aa列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_ab is 'ab列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_ac is 'ac列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_ad is 'ad列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_ae is 'ae列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_af is 'af列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.load_date is '加载时间';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.data_date is '数据日期(格式yyyymmdd)';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.solo_no is '法人机构编号';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_ag is 'ag列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_ah is 'ah列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_ai is 'ai列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_aj is 'aj列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_ak is 'ak列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_al is 'al列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_am is 'am列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_an is 'an列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_ao is 'ao列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_ap is 'ap列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_aq is 'aq列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_ar is 'ar列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_as is 'as列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_at is 'at列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_au is 'au列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_av is 'av列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_aw is 'aw列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_ax is 'ax列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_ay is 'ay列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_az is 'az列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_ba is 'ba列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_bb is 'bb列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_bc is 'bc列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_bd is 'bd列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_be is 'be列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_bf is 'bf列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_bg is 'bg列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_bh is 'bh列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_bi is 'bi列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_bj is 'bj列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_bk is 'bk列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_bl is 'bl列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_bm is 'bm列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_bn is 'bn列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_bo is 'bo列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_bp is 'bp列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_bq is 'bq列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_br is 'br列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_bs is 'bs列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_bt is 'bt列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_bu is 'bu列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_bv is 'bv列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_bw is 'bw列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_bx is 'bx列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_by is 'by列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_bz is 'bz列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_ca is 'ca列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_cb is 'cb列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_cc is 'cc列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_ccd is 'cd列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_ce is 'ce列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_cf is 'cf列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_cg is 'cg列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_ch is 'ch列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_ci is 'ci列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_cj is 'cj列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_ck is 'ck列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_cl is 'cl列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_cm is 'cm列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_cn is 'cn列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_co is 'co列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_cp is 'cp列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_cq is 'cq列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_cr is 'cr列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_cs is 'cs列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_ct is 'ct列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_cu is 'cu列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_cv is 'cv列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_cw is 'cw列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_cx is 'cx列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_cy is 'cy列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.item_cz is 'cz列';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.org_cd is '机构编号';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.ccy_cd is '币种编号';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.version is '版本';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.version_status is '版本状态，1-保存，2-审批中，3-正式版本， 4-历史版本';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.operate_dt is '操作时间';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.operate_id is '操作人id';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.operate_name is '操作人姓名';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.flow_starter_id is '流程发起人id';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_data_arc.flow_starter_name is '流程发起人姓名';
