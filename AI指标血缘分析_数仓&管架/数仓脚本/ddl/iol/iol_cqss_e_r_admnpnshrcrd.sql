/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_e_r_admnpnshrcrd
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_e_r_admnpnshrcrd
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_e_r_admnpnshrcrd purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_e_r_admnpnshrcrd(
    id varchar2(96) -- 代码主键
    ,msgidno varchar2(53) -- 报文标识号
    ,multi_tenancy_id varchar2(30) -- 多实体标识
    ,cr_inf_id varchar2(9) -- 征信信息编号:ef040i01
    ,inst_nm varchar2(360) -- 机构名称(处罚机构名称):ef040q01
    ,pnsh_wrtdcs_no varchar2(450) -- 处罚决定书文号:ef040i02
    ,admnpnshillg_bhvr_dsc varchar2(2250) -- 行政处罚违法行为描述(违法行为):ef040q02
    ,pnsh_dcd_dsc varchar2(2250) -- 处罚决定描述(处罚决定):ef040q03
    ,cr_admn_pnsh_efdt date -- 征信行政处罚生效日期(处罚日期):ef040r01
    ,cr_admn_pnsh_amt number(38,0) -- 征信行政处罚金额(处罚金额):ef040j01
    ,admn_pnsh_exec_stndsc varchar2(2250) -- 行政处罚执行情况描述(处罚执行情况):ef040q04
    ,cradmnpnshanrcnsdrslt varchar2(900) -- 征信行政处罚行政复议结果(行政复议结果):ef040q05
    ,crt_dt_tm date -- 创建日期时间
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.cqss_e_r_admnpnshrcrd to ${iml_schema};
grant select on ${iol_schema}.cqss_e_r_admnpnshrcrd to ${icl_schema};
grant select on ${iol_schema}.cqss_e_r_admnpnshrcrd to ${idl_schema};
grant select on ${iol_schema}.cqss_e_r_admnpnshrcrd to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_e_r_admnpnshrcrd is '行政处罚记录';
comment on column ${iol_schema}.cqss_e_r_admnpnshrcrd.id is '代码主键';
comment on column ${iol_schema}.cqss_e_r_admnpnshrcrd.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_e_r_admnpnshrcrd.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_e_r_admnpnshrcrd.cr_inf_id is '征信信息编号:ef040i01';
comment on column ${iol_schema}.cqss_e_r_admnpnshrcrd.inst_nm is '机构名称(处罚机构名称):ef040q01';
comment on column ${iol_schema}.cqss_e_r_admnpnshrcrd.pnsh_wrtdcs_no is '处罚决定书文号:ef040i02';
comment on column ${iol_schema}.cqss_e_r_admnpnshrcrd.admnpnshillg_bhvr_dsc is '行政处罚违法行为描述(违法行为):ef040q02';
comment on column ${iol_schema}.cqss_e_r_admnpnshrcrd.pnsh_dcd_dsc is '处罚决定描述(处罚决定):ef040q03';
comment on column ${iol_schema}.cqss_e_r_admnpnshrcrd.cr_admn_pnsh_efdt is '征信行政处罚生效日期(处罚日期):ef040r01';
comment on column ${iol_schema}.cqss_e_r_admnpnshrcrd.cr_admn_pnsh_amt is '征信行政处罚金额(处罚金额):ef040j01';
comment on column ${iol_schema}.cqss_e_r_admnpnshrcrd.admn_pnsh_exec_stndsc is '行政处罚执行情况描述(处罚执行情况):ef040q04';
comment on column ${iol_schema}.cqss_e_r_admnpnshrcrd.cradmnpnshanrcnsdrslt is '征信行政处罚行政复议结果(行政复议结果):ef040q05';
comment on column ${iol_schema}.cqss_e_r_admnpnshrcrd.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_e_r_admnpnshrcrd.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_e_r_admnpnshrcrd.etl_timestamp is 'ETL处理时间戳';
