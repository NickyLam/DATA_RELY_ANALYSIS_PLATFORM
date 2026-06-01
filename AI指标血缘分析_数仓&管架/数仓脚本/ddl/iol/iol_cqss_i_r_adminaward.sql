/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_i_r_adminaward
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_i_r_adminaward
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_i_r_adminaward purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_i_r_adminaward(
    id varchar2(96) -- 代码主键
    ,msgidno varchar2(53) -- 报文标识号
    ,inst_nm varchar2(360) -- 机构名称:pf08aq01
    ,cr_admn_rwrd_cntnt varchar2(450) -- 征信行政奖励内容:pf08aq02
    ,cr_admn_rwrd_efdt varchar2(11) -- 征信行政奖励生效日期:pf08ar01
    ,cr_admn_rwrd_codt varchar2(11) -- 征信行政奖励截止日期:pf08ar02
    ,annttn_and_sttmnt_num number(22) -- 标注及声明个数:pf08zs01
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
grant select on ${iol_schema}.cqss_i_r_adminaward to ${iml_schema};
grant select on ${iol_schema}.cqss_i_r_adminaward to ${icl_schema};
grant select on ${iol_schema}.cqss_i_r_adminaward to ${idl_schema};
grant select on ${iol_schema}.cqss_i_r_adminaward to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_i_r_adminaward is '二代行政奖励记录信息';
comment on column ${iol_schema}.cqss_i_r_adminaward.id is '代码主键';
comment on column ${iol_schema}.cqss_i_r_adminaward.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_i_r_adminaward.inst_nm is '机构名称:pf08aq01';
comment on column ${iol_schema}.cqss_i_r_adminaward.cr_admn_rwrd_cntnt is '征信行政奖励内容:pf08aq02';
comment on column ${iol_schema}.cqss_i_r_adminaward.cr_admn_rwrd_efdt is '征信行政奖励生效日期:pf08ar01';
comment on column ${iol_schema}.cqss_i_r_adminaward.cr_admn_rwrd_codt is '征信行政奖励截止日期:pf08ar02';
comment on column ${iol_schema}.cqss_i_r_adminaward.annttn_and_sttmnt_num is '标注及声明个数:pf08zs01';
comment on column ${iol_schema}.cqss_i_r_adminaward.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_i_r_adminaward.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_i_r_adminaward.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_i_r_adminaward.etl_timestamp is 'ETL处理时间戳';
