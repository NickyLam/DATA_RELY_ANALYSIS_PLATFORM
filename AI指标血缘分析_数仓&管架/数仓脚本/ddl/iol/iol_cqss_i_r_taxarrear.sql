/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_i_r_taxarrear
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_i_r_taxarrear
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_i_r_taxarrear purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_i_r_taxarrear(
    id varchar2(96) -- 代码主键
    ,msgidno varchar2(53) -- 报文标识号
    ,inst_nm varchar2(360) -- 机构名称:pf01aq01
    ,cr_inarr_tax_tamt number(38,0) -- 征信拖欠税总额:pf01aj01
    ,cr_inarr_tax_stat_dt date -- 征信拖欠税统计日期:pf01ar01
    ,annttn_and_sttmnt_num number(22) -- 标注及声明个数
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
grant select on ${iol_schema}.cqss_i_r_taxarrear to ${iml_schema};
grant select on ${iol_schema}.cqss_i_r_taxarrear to ${icl_schema};
grant select on ${iol_schema}.cqss_i_r_taxarrear to ${idl_schema};
grant select on ${iol_schema}.cqss_i_r_taxarrear to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_i_r_taxarrear is '二代欠税记录信息';
comment on column ${iol_schema}.cqss_i_r_taxarrear.id is '代码主键';
comment on column ${iol_schema}.cqss_i_r_taxarrear.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_i_r_taxarrear.inst_nm is '机构名称:pf01aq01';
comment on column ${iol_schema}.cqss_i_r_taxarrear.cr_inarr_tax_tamt is '征信拖欠税总额:pf01aj01';
comment on column ${iol_schema}.cqss_i_r_taxarrear.cr_inarr_tax_stat_dt is '征信拖欠税统计日期:pf01ar01';
comment on column ${iol_schema}.cqss_i_r_taxarrear.annttn_and_sttmnt_num is '标注及声明个数';
comment on column ${iol_schema}.cqss_i_r_taxarrear.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_i_r_taxarrear.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_i_r_taxarrear.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_i_r_taxarrear.etl_timestamp is 'ETL处理时间戳';
