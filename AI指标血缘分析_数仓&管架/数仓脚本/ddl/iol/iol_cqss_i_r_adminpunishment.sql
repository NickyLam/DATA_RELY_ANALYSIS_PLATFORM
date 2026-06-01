/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_i_r_adminpunishment
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_i_r_adminpunishment
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_i_r_adminpunishment purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_i_r_adminpunishment(
    id varchar2(96) -- 代码主键
    ,msgidno varchar2(53) -- 报文标识号
    ,inst_nm varchar2(360) -- 机构名称:pf04aq01
    ,cr_admn_pnsh_cntnt varchar2(450) -- 征信行政处罚内容:pf04aq02
    ,cr_admn_pnsh_amt number(38,0) -- 征信行政处罚金额:pf04aj01
    ,cr_admn_pnsh_efdt varchar2(11) -- 征信行政处罚生效日期:pf04ar01
    ,cr_admn_pnsh_codt varchar2(11) -- 征信行政处罚截止日期:pf04ar02
    ,cradmnpnshanrcnsdrslt varchar2(360) -- 征信行政处罚行政复议结果:pf04aq03
    ,annttn_and_sttmnt_num number(22) -- 标注及声明个数:pf04zs01
    ,multi_tenancy_id varchar2(30) -- 多实体标识
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
grant select on ${iol_schema}.cqss_i_r_adminpunishment to ${iml_schema};
grant select on ${iol_schema}.cqss_i_r_adminpunishment to ${icl_schema};
grant select on ${iol_schema}.cqss_i_r_adminpunishment to ${idl_schema};
grant select on ${iol_schema}.cqss_i_r_adminpunishment to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_i_r_adminpunishment is '二代行政处罚记录';
comment on column ${iol_schema}.cqss_i_r_adminpunishment.id is '代码主键';
comment on column ${iol_schema}.cqss_i_r_adminpunishment.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_i_r_adminpunishment.inst_nm is '机构名称:pf04aq01';
comment on column ${iol_schema}.cqss_i_r_adminpunishment.cr_admn_pnsh_cntnt is '征信行政处罚内容:pf04aq02';
comment on column ${iol_schema}.cqss_i_r_adminpunishment.cr_admn_pnsh_amt is '征信行政处罚金额:pf04aj01';
comment on column ${iol_schema}.cqss_i_r_adminpunishment.cr_admn_pnsh_efdt is '征信行政处罚生效日期:pf04ar01';
comment on column ${iol_schema}.cqss_i_r_adminpunishment.cr_admn_pnsh_codt is '征信行政处罚截止日期:pf04ar02';
comment on column ${iol_schema}.cqss_i_r_adminpunishment.cradmnpnshanrcnsdrslt is '征信行政处罚行政复议结果:pf04aq03';
comment on column ${iol_schema}.cqss_i_r_adminpunishment.annttn_and_sttmnt_num is '标注及声明个数:pf04zs01';
comment on column ${iol_schema}.cqss_i_r_adminpunishment.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_i_r_adminpunishment.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_i_r_adminpunishment.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_i_r_adminpunishment.etl_timestamp is 'ETL处理时间戳';
