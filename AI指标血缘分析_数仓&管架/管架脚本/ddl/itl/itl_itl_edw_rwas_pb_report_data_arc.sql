/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_edw_rwas_pb_report_data_arc
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_edw_rwas_pb_report_data_arc
whenever sqlerror continue none;
drop table ${itl_schema}.itl_edw_rwas_pb_report_data_arc purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_edw_rwas_pb_report_data_arc(
    data_id varchar2(765) -- 主键id
    ,item_cd varchar2(90) -- 报表编码
    ,item_name varchar2(150) -- 报表名称
    ,line_number number(38) -- 行号
    ,item_a varchar2(1500) -- a列
    ,item_b varchar2(4000) -- b列
    ,item_c varchar2(4000) -- c列
    ,item_d varchar2(300) -- d列
    ,item_e varchar2(300) -- e列
    ,item_f varchar2(300) -- f列
    ,item_g varchar2(300) -- g列
    ,item_h varchar2(300) -- h列
    ,item_i varchar2(300) -- i列
    ,item_j varchar2(300) -- j列
    ,item_k varchar2(300) -- k列
    ,item_l varchar2(300) -- l列
    ,item_m varchar2(300) -- m列
    ,item_n varchar2(300) -- n列
    ,item_o varchar2(300) -- o列
    ,item_p varchar2(300) -- p列
    ,item_q varchar2(300) -- q列
    ,item_r varchar2(300) -- r列
    ,item_s varchar2(300) -- s列
    ,item_t varchar2(300) -- t列
    ,item_u varchar2(300) -- u列
    ,item_v varchar2(300) -- v列
    ,item_w varchar2(300) -- w列
    ,item_x varchar2(300) -- x列
    ,item_y varchar2(300) -- y列
    ,item_z varchar2(300) -- z列
    ,item_aa varchar2(300) -- aa列
    ,item_ab varchar2(300) -- ab列
    ,item_ac varchar2(300) -- ac列
    ,item_ad varchar2(300) -- ad列
    ,item_ae varchar2(300) -- ae列
    ,item_af varchar2(300) -- af列
    ,load_date varchar2(60) -- 加载时间
    ,data_date varchar2(30) -- 数据日期(格式yyyymmdd)
    ,solo_no varchar2(60) -- 法人机构编号
    ,item_ag varchar2(300) -- ag列
    ,item_ah varchar2(300) -- ah列
    ,item_ai varchar2(300) -- ai列
    ,item_aj varchar2(300) -- aj列
    ,item_ak varchar2(300) -- ak列
    ,item_al varchar2(300) -- al列
    ,item_am varchar2(300) -- am列
    ,item_an varchar2(300) -- an列
    ,item_ao varchar2(300) -- ao列
    ,item_ap varchar2(300) -- ap列
    ,item_aq varchar2(300) -- aq列
    ,item_ar varchar2(300) -- ar列
    ,item_as varchar2(300) -- as列
    ,item_at varchar2(300) -- at列
    ,item_au varchar2(300) -- au列
    ,item_av varchar2(300) -- av列
    ,item_aw varchar2(300) -- aw列
    ,item_ax varchar2(300) -- ax列
    ,item_ay varchar2(300) -- ay列
    ,item_az varchar2(300) -- az列
    ,item_ba varchar2(300) -- ba列
    ,item_bb varchar2(300) -- bb列
    ,item_bc varchar2(300) -- bc列
    ,item_bd varchar2(300) -- bd列
    ,item_be varchar2(300) -- be列
    ,item_bf varchar2(300) -- bf列
    ,item_bg varchar2(300) -- bg列
    ,item_bh varchar2(300) -- bh列
    ,item_bi varchar2(300) -- bi列
    ,item_bj varchar2(300) -- bj列
    ,item_bk varchar2(300) -- bk列
    ,item_bl varchar2(300) -- bl列
    ,item_bm varchar2(300) -- bm列
    ,item_bn varchar2(300) -- bn列
    ,item_bo varchar2(300) -- bo列
    ,item_bp varchar2(300) -- bp列
    ,item_bq varchar2(300) -- bq列
    ,item_br varchar2(300) -- br列
    ,item_bs varchar2(300) -- bs列
    ,item_bt varchar2(300) -- bt列
    ,item_bu varchar2(300) -- bu列
    ,item_bv varchar2(300) -- bv列
    ,item_bw varchar2(300) -- bw列
    ,item_bx varchar2(300) -- bx列
    ,item_by varchar2(300) -- by列
    ,item_bz varchar2(300) -- bz列
    ,item_ca varchar2(300) -- ca列
    ,item_cb varchar2(300) -- cb列
    ,item_cc varchar2(300) -- cc列
    ,item_ccd varchar2(300) -- cd列
    ,item_ce varchar2(300) -- ce列
    ,item_cf varchar2(300) -- cf列
    ,item_cg varchar2(300) -- cg列
    ,item_ch varchar2(300) -- ch列
    ,item_ci varchar2(300) -- ci列
    ,item_cj varchar2(300) -- cj列
    ,item_ck varchar2(300) -- ck列
    ,item_cl varchar2(300) -- cl列
    ,item_cm varchar2(300) -- cm列
    ,item_cn varchar2(300) -- cn列
    ,item_co varchar2(300) -- co列
    ,item_cp varchar2(300) -- cp列
    ,item_cq varchar2(300) -- cq列
    ,item_cr varchar2(300) -- cr列
    ,item_cs varchar2(300) -- cs列
    ,item_ct varchar2(300) -- ct列
    ,item_cu varchar2(300) -- cu列
    ,item_cv varchar2(300) -- cv列
    ,item_cw varchar2(300) -- cw列
    ,item_cx varchar2(300) -- cx列
    ,item_cy varchar2(300) -- cy列
    ,item_cz varchar2(300) -- cz列
    ,org_cd varchar2(60) -- 机构编号
    ,ccy_cd varchar2(60) -- 币种编号
    ,version varchar2(150) -- 版本
    ,version_status number(22) -- 版本状态，1-保存，2-审批中，3-正式版本， 4-历史版本
    ,operate_dt varchar2(75) -- 操作时间
    ,operate_id varchar2(75) -- 操作人id
    ,operate_name varchar2(383) -- 操作人姓名
    ,flow_starter_id varchar2(75) -- 流程发起人id
    ,flow_starter_name varchar2(383) -- 流程发起人姓名
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${itl_schema}.itl_edw_rwas_pb_report_data_arc to ${iol_schema};

-- comment
comment on table ${itl_schema}.itl_edw_rwas_pb_report_data_arc is '公共报表数据表-归档数据';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.data_id is '主键id';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_cd is '报表编码';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_name is '报表名称';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.line_number is '行号';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_a is 'a列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_b is 'b列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_c is 'c列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_d is 'd列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_e is 'e列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_f is 'f列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_g is 'g列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_h is 'h列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_i is 'i列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_j is 'j列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_k is 'k列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_l is 'l列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_m is 'm列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_n is 'n列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_o is 'o列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_p is 'p列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_q is 'q列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_r is 'r列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_s is 's列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_t is 't列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_u is 'u列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_v is 'v列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_w is 'w列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_x is 'x列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_y is 'y列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_z is 'z列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_aa is 'aa列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_ab is 'ab列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_ac is 'ac列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_ad is 'ad列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_ae is 'ae列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_af is 'af列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.load_date is '加载时间';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.data_date is '数据日期(格式yyyymmdd)';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.solo_no is '法人机构编号';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_ag is 'ag列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_ah is 'ah列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_ai is 'ai列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_aj is 'aj列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_ak is 'ak列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_al is 'al列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_am is 'am列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_an is 'an列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_ao is 'ao列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_ap is 'ap列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_aq is 'aq列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_ar is 'ar列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_as is 'as列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_at is 'at列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_au is 'au列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_av is 'av列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_aw is 'aw列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_ax is 'ax列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_ay is 'ay列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_az is 'az列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_ba is 'ba列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_bb is 'bb列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_bc is 'bc列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_bd is 'bd列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_be is 'be列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_bf is 'bf列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_bg is 'bg列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_bh is 'bh列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_bi is 'bi列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_bj is 'bj列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_bk is 'bk列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_bl is 'bl列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_bm is 'bm列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_bn is 'bn列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_bo is 'bo列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_bp is 'bp列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_bq is 'bq列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_br is 'br列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_bs is 'bs列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_bt is 'bt列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_bu is 'bu列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_bv is 'bv列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_bw is 'bw列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_bx is 'bx列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_by is 'by列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_bz is 'bz列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_ca is 'ca列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_cb is 'cb列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_cc is 'cc列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_ccd is 'cd列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_ce is 'ce列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_cf is 'cf列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_cg is 'cg列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_ch is 'ch列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_ci is 'ci列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_cj is 'cj列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_ck is 'ck列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_cl is 'cl列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_cm is 'cm列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_cn is 'cn列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_co is 'co列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_cp is 'cp列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_cq is 'cq列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_cr is 'cr列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_cs is 'cs列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_ct is 'ct列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_cu is 'cu列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_cv is 'cv列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_cw is 'cw列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_cx is 'cx列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_cy is 'cy列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.item_cz is 'cz列';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.org_cd is '机构编号';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.ccy_cd is '币种编号';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.version is '版本';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.version_status is '版本状态，1-保存，2-审批中，3-正式版本， 4-历史版本';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.operate_dt is '操作时间';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.operate_id is '操作人id';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.operate_name is '操作人姓名';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.flow_starter_id is '流程发起人id';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.flow_starter_name is '流程发起人姓名';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.etl_dt is 'ETL处理日期';
comment on column ${itl_schema}.itl_edw_rwas_pb_report_data_arc.etl_timestamp is 'ETL处理时间戳';
