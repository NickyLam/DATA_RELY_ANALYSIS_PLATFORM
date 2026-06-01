/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol eifs_fins_report_data
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.eifs_fins_report_data
whenever sqlerror continue none;
drop table ${iol_schema}.eifs_fins_report_data purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.eifs_fins_report_data(
    data_id number(20) -- 数据主表id  数据主表id
    ,tplt_id number(20) -- 模板id  模板id
    ,party_id varchar2(30) -- 客户序号  客户序号
    ,indu_type varchar2(30) -- 客户所属行业  客户所属行业
    ,rpt_type varchar2(30) -- 报表类型  报表类型
    ,rpt_perd_type varchar2(30) -- 报表期限类型，月报、季报、半年报、年报  报表期限类型，月报、季报、半年报、年报
    ,rpt_date date -- 报表日期  报表日期
    ,unite_flag varchar2(15) -- 是否合并报表  是否合并报表
    ,check_flag varchar2(15) -- 是否审计  是否审计
    ,remark varchar2(383) -- 备注  备注
    ,ver number(8) -- 版本  版本
    ,crt_usr varchar2(15) -- 创建人  创建人
    ,crt_dt date -- 创建日期  创建日期
    ,last_upd_usr varchar2(15) -- 最后修改人  最后修改人
    ,last_upd_dt date -- 最后修改日期  最后修改日期
    ,last_updated_stamp timestamp -- 最后更新时间
    ,last_updated_tx_stamp timestamp -- 最后更新事务时间
    ,created_stamp timestamp -- 创建时间
    ,created_tx_stamp timestamp -- 创建事务时间
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
grant select on ${iol_schema}.eifs_fins_report_data to ${iml_schema};
grant select on ${iol_schema}.eifs_fins_report_data to ${icl_schema};
grant select on ${iol_schema}.eifs_fins_report_data to ${idl_schema};
grant select on ${iol_schema}.eifs_fins_report_data to ${iel_schema};

-- comment
comment on table ${iol_schema}.eifs_fins_report_data is '财务报表数据主表';
comment on column ${iol_schema}.eifs_fins_report_data.data_id is '数据主表id  数据主表id';
comment on column ${iol_schema}.eifs_fins_report_data.tplt_id is '模板id  模板id';
comment on column ${iol_schema}.eifs_fins_report_data.party_id is '客户序号  客户序号';
comment on column ${iol_schema}.eifs_fins_report_data.indu_type is '客户所属行业  客户所属行业';
comment on column ${iol_schema}.eifs_fins_report_data.rpt_type is '报表类型  报表类型';
comment on column ${iol_schema}.eifs_fins_report_data.rpt_perd_type is '报表期限类型，月报、季报、半年报、年报  报表期限类型，月报、季报、半年报、年报';
comment on column ${iol_schema}.eifs_fins_report_data.rpt_date is '报表日期  报表日期';
comment on column ${iol_schema}.eifs_fins_report_data.unite_flag is '是否合并报表  是否合并报表';
comment on column ${iol_schema}.eifs_fins_report_data.check_flag is '是否审计  是否审计';
comment on column ${iol_schema}.eifs_fins_report_data.remark is '备注  备注';
comment on column ${iol_schema}.eifs_fins_report_data.ver is '版本  版本';
comment on column ${iol_schema}.eifs_fins_report_data.crt_usr is '创建人  创建人';
comment on column ${iol_schema}.eifs_fins_report_data.crt_dt is '创建日期  创建日期';
comment on column ${iol_schema}.eifs_fins_report_data.last_upd_usr is '最后修改人  最后修改人';
comment on column ${iol_schema}.eifs_fins_report_data.last_upd_dt is '最后修改日期  最后修改日期';
comment on column ${iol_schema}.eifs_fins_report_data.last_updated_stamp is '最后更新时间';
comment on column ${iol_schema}.eifs_fins_report_data.last_updated_tx_stamp is '最后更新事务时间';
comment on column ${iol_schema}.eifs_fins_report_data.created_stamp is '创建时间';
comment on column ${iol_schema}.eifs_fins_report_data.created_tx_stamp is '创建事务时间';
comment on column ${iol_schema}.eifs_fins_report_data.start_dt is '开始时间';
comment on column ${iol_schema}.eifs_fins_report_data.end_dt is '结束时间';
comment on column ${iol_schema}.eifs_fins_report_data.id_mark is '增删标志';
comment on column ${iol_schema}.eifs_fins_report_data.etl_timestamp is 'ETL处理时间戳';
