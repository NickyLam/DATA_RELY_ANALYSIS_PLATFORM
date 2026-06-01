/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rwas_pb_report_data_arc
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rwas_pb_report_data_arc
whenever sqlerror continue none;
drop table ${iol_schema}.rwas_pb_report_data_arc purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rwas_pb_report_data_arc(
    data_id varchar2(510) -- 主键ID
    ,item_cd varchar2(60) -- 报表编码
    ,item_name varchar2(100) -- 报表名称
    ,line_number number(38,0) -- 行号
    ,item_a varchar2(1000) -- A列
    ,item_b varchar2(4000) -- B列
    ,item_c varchar2(4000) -- C列
    ,item_d varchar2(200) -- D列
    ,item_e varchar2(200) -- E列
    ,item_f varchar2(200) -- F列
    ,item_g varchar2(200) -- G列
    ,item_h varchar2(200) -- H列
    ,item_i varchar2(200) -- I列
    ,item_j varchar2(200) -- J列
    ,item_k varchar2(200) -- K列
    ,item_l varchar2(200) -- L列
    ,item_m varchar2(200) -- M列
    ,item_n varchar2(200) -- N列
    ,item_o varchar2(200) -- O列
    ,item_p varchar2(200) -- P列
    ,item_q varchar2(200) -- Q列
    ,item_r varchar2(200) -- R列
    ,item_s varchar2(200) -- S列
    ,item_t varchar2(200) -- T列
    ,item_u varchar2(200) -- U列
    ,item_v varchar2(200) -- V列
    ,item_w varchar2(200) -- W列
    ,item_x varchar2(200) -- X列
    ,item_y varchar2(200) -- Y列
    ,item_z varchar2(200) -- Z列
    ,item_aa varchar2(200) -- AA列
    ,item_ab varchar2(200) -- AB列
    ,item_ac varchar2(200) -- AC列
    ,item_ad varchar2(200) -- AD列
    ,item_ae varchar2(200) -- AE列
    ,item_af varchar2(200) -- AF列
    ,load_date varchar2(40) -- 加载时间
    ,data_date varchar2(20) -- 数据日期(格式YYYYMMDD)
    ,solo_no varchar2(40) -- 法人机构编号
    ,item_ag varchar2(200) -- AG列
    ,item_ah varchar2(200) -- AH列
    ,item_ai varchar2(200) -- AI列
    ,item_aj varchar2(200) -- AJ列
    ,item_ak varchar2(200) -- AK列
    ,item_al varchar2(200) -- AL列
    ,item_am varchar2(200) -- AM列
    ,item_an varchar2(200) -- AN列
    ,item_ao varchar2(200) -- AO列
    ,item_ap varchar2(200) -- AP列
    ,item_aq varchar2(200) -- AQ列
    ,item_ar varchar2(200) -- AR列
    ,item_as varchar2(200) -- AS列
    ,item_at varchar2(200) -- AT列
    ,item_au varchar2(200) -- AU列
    ,item_av varchar2(200) -- AV列
    ,item_aw varchar2(200) -- AW列
    ,item_ax varchar2(200) -- AX列
    ,item_ay varchar2(200) -- AY列
    ,item_az varchar2(200) -- AZ列
    ,item_ba varchar2(200) -- BA列
    ,item_bb varchar2(200) -- BB列
    ,item_bc varchar2(200) -- BC列
    ,item_bd varchar2(200) -- BD列
    ,item_be varchar2(200) -- BE列
    ,item_bf varchar2(200) -- BF列
    ,item_bg varchar2(200) -- BG列
    ,item_bh varchar2(200) -- BH列
    ,item_bi varchar2(200) -- BI列
    ,item_bj varchar2(200) -- BJ列
    ,item_bk varchar2(200) -- BK列
    ,item_bl varchar2(200) -- BL列
    ,item_bm varchar2(200) -- BM列
    ,item_bn varchar2(200) -- BN列
    ,item_bo varchar2(200) -- BO列
    ,item_bp varchar2(200) -- BP列
    ,item_bq varchar2(200) -- BQ列
    ,item_br varchar2(200) -- BR列
    ,item_bs varchar2(200) -- BS列
    ,item_bt varchar2(200) -- BT列
    ,item_bu varchar2(200) -- BU列
    ,item_bv varchar2(200) -- BV列
    ,item_bw varchar2(200) -- BW列
    ,item_bx varchar2(200) -- BX列
    ,item_by varchar2(200) -- BY列
    ,item_bz varchar2(200) -- BZ列
    ,item_ca varchar2(200) -- CA列
    ,item_cb varchar2(200) -- CB列
    ,item_cc varchar2(200) -- CC列
    ,item_ccd varchar2(200) -- CD列
    ,item_ce varchar2(200) -- CE列
    ,item_cf varchar2(200) -- CF列
    ,item_cg varchar2(200) -- CG列
    ,item_ch varchar2(200) -- CH列
    ,item_ci varchar2(200) -- CI列
    ,item_cj varchar2(200) -- CJ列
    ,item_ck varchar2(200) -- CK列
    ,item_cl varchar2(200) -- CL列
    ,item_cm varchar2(200) -- CM列
    ,item_cn varchar2(200) -- CN列
    ,item_co varchar2(200) -- CO列
    ,item_cp varchar2(200) -- CP列
    ,item_cq varchar2(200) -- CQ列
    ,item_cr varchar2(200) -- CR列
    ,item_cs varchar2(200) -- CS列
    ,item_ct varchar2(200) -- CT列
    ,item_cu varchar2(200) -- CU列
    ,item_cv varchar2(200) -- CV列
    ,item_cw varchar2(200) -- CW列
    ,item_cx varchar2(200) -- CX列
    ,item_cy varchar2(200) -- CY列
    ,item_cz varchar2(200) -- CZ列
    ,org_cd varchar2(40) -- 机构编号
    ,ccy_cd varchar2(40) -- 币种编号
    ,version varchar2(100) -- 版本
    ,version_status number(22) -- 版本状态，1-保存，2-审批中，3-正式版本， 4-历史版本
    ,operate_dt varchar2(50) -- 操作时间
    ,operate_id varchar2(50) -- 操作人ID
    ,operate_name varchar2(255) -- 操作人姓名
    ,flow_starter_id varchar2(50) -- 流程发起人ID
    ,flow_starter_name varchar2(255) -- 流程发起人姓名
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.rwas_pb_report_data_arc to ${iml_schema};
grant select on ${iol_schema}.rwas_pb_report_data_arc to ${icl_schema};
grant select on ${iol_schema}.rwas_pb_report_data_arc to ${idl_schema};
grant select on ${iol_schema}.rwas_pb_report_data_arc to ${iel_schema};

-- comment
comment on table ${iol_schema}.rwas_pb_report_data_arc is '公共报表数据表-归档数据';
comment on column ${iol_schema}.rwas_pb_report_data_arc.data_id is '主键ID';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_cd is '报表编码';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_name is '报表名称';
comment on column ${iol_schema}.rwas_pb_report_data_arc.line_number is '行号';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_a is 'A列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_b is 'B列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_c is 'C列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_d is 'D列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_e is 'E列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_f is 'F列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_g is 'G列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_h is 'H列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_i is 'I列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_j is 'J列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_k is 'K列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_l is 'L列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_m is 'M列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_n is 'N列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_o is 'O列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_p is 'P列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_q is 'Q列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_r is 'R列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_s is 'S列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_t is 'T列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_u is 'U列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_v is 'V列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_w is 'W列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_x is 'X列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_y is 'Y列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_z is 'Z列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_aa is 'AA列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_ab is 'AB列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_ac is 'AC列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_ad is 'AD列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_ae is 'AE列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_af is 'AF列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.load_date is '加载时间';
comment on column ${iol_schema}.rwas_pb_report_data_arc.data_date is '数据日期(格式YYYYMMDD)';
comment on column ${iol_schema}.rwas_pb_report_data_arc.solo_no is '法人机构编号';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_ag is 'AG列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_ah is 'AH列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_ai is 'AI列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_aj is 'AJ列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_ak is 'AK列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_al is 'AL列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_am is 'AM列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_an is 'AN列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_ao is 'AO列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_ap is 'AP列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_aq is 'AQ列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_ar is 'AR列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_as is 'AS列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_at is 'AT列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_au is 'AU列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_av is 'AV列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_aw is 'AW列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_ax is 'AX列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_ay is 'AY列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_az is 'AZ列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_ba is 'BA列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_bb is 'BB列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_bc is 'BC列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_bd is 'BD列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_be is 'BE列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_bf is 'BF列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_bg is 'BG列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_bh is 'BH列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_bi is 'BI列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_bj is 'BJ列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_bk is 'BK列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_bl is 'BL列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_bm is 'BM列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_bn is 'BN列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_bo is 'BO列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_bp is 'BP列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_bq is 'BQ列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_br is 'BR列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_bs is 'BS列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_bt is 'BT列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_bu is 'BU列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_bv is 'BV列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_bw is 'BW列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_bx is 'BX列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_by is 'BY列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_bz is 'BZ列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_ca is 'CA列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_cb is 'CB列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_cc is 'CC列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_ccd is 'CD列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_ce is 'CE列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_cf is 'CF列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_cg is 'CG列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_ch is 'CH列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_ci is 'CI列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_cj is 'CJ列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_ck is 'CK列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_cl is 'CL列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_cm is 'CM列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_cn is 'CN列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_co is 'CO列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_cp is 'CP列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_cq is 'CQ列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_cr is 'CR列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_cs is 'CS列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_ct is 'CT列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_cu is 'CU列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_cv is 'CV列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_cw is 'CW列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_cx is 'CX列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_cy is 'CY列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.item_cz is 'CZ列';
comment on column ${iol_schema}.rwas_pb_report_data_arc.org_cd is '机构编号';
comment on column ${iol_schema}.rwas_pb_report_data_arc.ccy_cd is '币种编号';
comment on column ${iol_schema}.rwas_pb_report_data_arc.version is '版本';
comment on column ${iol_schema}.rwas_pb_report_data_arc.version_status is '版本状态，1-保存，2-审批中，3-正式版本， 4-历史版本';
comment on column ${iol_schema}.rwas_pb_report_data_arc.operate_dt is '操作时间';
comment on column ${iol_schema}.rwas_pb_report_data_arc.operate_id is '操作人ID';
comment on column ${iol_schema}.rwas_pb_report_data_arc.operate_name is '操作人姓名';
comment on column ${iol_schema}.rwas_pb_report_data_arc.flow_starter_id is '流程发起人ID';
comment on column ${iol_schema}.rwas_pb_report_data_arc.flow_starter_name is '流程发起人姓名';
comment on column ${iol_schema}.rwas_pb_report_data_arc.start_dt is '开始时间';
comment on column ${iol_schema}.rwas_pb_report_data_arc.end_dt is '结束时间';
comment on column ${iol_schema}.rwas_pb_report_data_arc.id_mark is '增删标志';
comment on column ${iol_schema}.rwas_pb_report_data_arc.etl_timestamp is 'ETL处理时间戳';
