/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ref_tszfs_corp_info_para
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ref_tszfs_corp_info_para
whenever sqlerror continue none;
drop table ${iml_schema}.ref_tszfs_corp_info_para purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_tszfs_corp_info_para(
    corp_id varchar2(60) -- 企业编号
    ,corp_name varchar2(375) -- 企业名称
    ,corp_addr varchar2(375) -- 企业地址
    ,corp_crdt_level_cd varchar2(10) -- 企业信用等级代码
    ,corp_cotas_name varchar2(375) -- 企业联系人姓名
    ,corp_phone_num varchar2(30) -- 企业联系电话号码
    ,zip_cd varchar2(45) -- 邮政编码
    ,elec_mail_addr varchar2(375) -- 电子邮件地址
    ,indit_mercht_flg varchar2(10) -- 间接商户标志
    ,corp_status_cd varchar2(10) -- 企业状态代码
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by range (end_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_default_20991231 values less than (maxvalue)
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.ref_tszfs_corp_info_para to ${icl_schema};
grant select on ${iml_schema}.ref_tszfs_corp_info_para to ${idl_schema};
grant select on ${iml_schema}.ref_tszfs_corp_info_para to ${iel_schema};

-- comment
comment on table ${iml_schema}.ref_tszfs_corp_info_para is '深同城企业信息参数';
comment on column ${iml_schema}.ref_tszfs_corp_info_para.corp_id is '企业编号';
comment on column ${iml_schema}.ref_tszfs_corp_info_para.corp_name is '企业名称';
comment on column ${iml_schema}.ref_tszfs_corp_info_para.corp_addr is '企业地址';
comment on column ${iml_schema}.ref_tszfs_corp_info_para.corp_crdt_level_cd is '企业信用等级代码';
comment on column ${iml_schema}.ref_tszfs_corp_info_para.corp_cotas_name is '企业联系人姓名';
comment on column ${iml_schema}.ref_tszfs_corp_info_para.corp_phone_num is '企业联系电话号码';
comment on column ${iml_schema}.ref_tszfs_corp_info_para.zip_cd is '邮政编码';
comment on column ${iml_schema}.ref_tszfs_corp_info_para.elec_mail_addr is '电子邮件地址';
comment on column ${iml_schema}.ref_tszfs_corp_info_para.indit_mercht_flg is '间接商户标志';
comment on column ${iml_schema}.ref_tszfs_corp_info_para.corp_status_cd is '企业状态代码';
comment on column ${iml_schema}.ref_tszfs_corp_info_para.start_dt is '开始时间';
comment on column ${iml_schema}.ref_tszfs_corp_info_para.end_dt is '结束时间';
comment on column ${iml_schema}.ref_tszfs_corp_info_para.id_mark is '增删标志';
comment on column ${iml_schema}.ref_tszfs_corp_info_para.src_table_name is '源表名称';
comment on column ${iml_schema}.ref_tszfs_corp_info_para.job_cd is '任务编码';
comment on column ${iml_schema}.ref_tszfs_corp_info_para.etl_timestamp is 'ETL处理时间戳';
