/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_icl_enty_tab_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_icl_enty_tab_info
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_icl_enty_tab_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_icl_enty_tab_info(
    tab_seq_num varchar2(10) -- 表序号
    ,tab_en_name varchar2(60) -- 表英文名称
    ,tab_cn_name varchar2(100) -- 表中文名称
    ,analy_person varchar2(60) -- 分析人员
    ,belong_levl varchar2(10) -- 归属层次
    ,belong_subj varchar2(60) -- 归属主题
    ,tm_part_sz varchar2(10) -- 时间粒度
    ,pk_field varchar2(100) -- 主键字段
    ,parti_type varchar2(10) -- 分区类型
    ,parti_field varchar2(60) -- 分区字段
    ,resv_ped number(10) -- 保留周期
    ,resv_ped_corp varchar2(10) -- 保留周期单位
    ,is_resv_monend varchar2(10) -- 是否保留月末
    ,create_dt date -- 创建日期
    ,remark varchar2(2000) -- 备注
 --   ,etl_dt date -- ETL处理日期
   -- ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${icl_schema}.cmm_icl_enty_tab_info to ${idl_schema};
grant select on ${icl_schema}.cmm_icl_enty_tab_info to ${iel_schema};
grant select on ${icl_schema}.cmm_icl_enty_tab_info to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_icl_enty_tab_info is '共性加工层实体表信息';
comment on column ${icl_schema}.cmm_icl_enty_tab_info.tab_seq_num is '表序号';
comment on column ${icl_schema}.cmm_icl_enty_tab_info.tab_en_name is '表英文名称';
comment on column ${icl_schema}.cmm_icl_enty_tab_info.tab_cn_name is '表中文名称';
comment on column ${icl_schema}.cmm_icl_enty_tab_info.analy_person is '分析人员';
comment on column ${icl_schema}.cmm_icl_enty_tab_info.belong_levl is '归属层次';
comment on column ${icl_schema}.cmm_icl_enty_tab_info.belong_subj is '归属主题';
comment on column ${icl_schema}.cmm_icl_enty_tab_info.tm_part_sz is '时间粒度';
comment on column ${icl_schema}.cmm_icl_enty_tab_info.pk_field is '主键字段';
comment on column ${icl_schema}.cmm_icl_enty_tab_info.parti_type is '分区类型';
comment on column ${icl_schema}.cmm_icl_enty_tab_info.parti_field is '分区字段';
comment on column ${icl_schema}.cmm_icl_enty_tab_info.resv_ped is '保留周期';
comment on column ${icl_schema}.cmm_icl_enty_tab_info.resv_ped_corp is '保留周期单位';
comment on column ${icl_schema}.cmm_icl_enty_tab_info.is_resv_monend is '是否保留月末';
comment on column ${icl_schema}.cmm_icl_enty_tab_info.create_dt is '创建日期';
comment on column ${icl_schema}.cmm_icl_enty_tab_info.remark is '备注';
--comment on column ${icl_schema}.cmm_icl_enty_tab_info.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_icl_enty_tab_info.etl_timestamp is 'ETL处理时间戳';
