/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fams_ban_bok_tax
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fams_ban_bok_tax
whenever sqlerror continue none;
drop table ${iol_schema}.fams_ban_bok_tax purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_ban_bok_tax(
    cdate date -- 数据日期
    ,org_no varchar2(50) -- 机构编号
    ,org_name varchar2(200) -- 机构名称
    ,ccy varchar2(50) -- 币种
    ,subject_no varchar2(30) -- 科目编号
    ,subject_name varchar2(200) -- 科目名称
    ,prod_code varchar2(12) -- 产品
    ,business varchar2(50) -- 业务场景
    ,tax_type varchar2(50) -- 计税方法
    ,tax_rate varchar2(50) -- 税率
    ,tax_nature varchar2(50) -- 税目
    ,tax_code varchar2(50) -- 免税代码
    ,amount number(30,2) -- 期间收入累计数
    ,amt number(30,2) -- 期间累计税额
    ,bill_no varchar2(50) -- 发票号码
    ,busi_id varchar2(200) -- 业务流水
    ,source varchar2(10) -- 来源系统
    ,create_user varchar2(20) -- 创建人
    ,create_dept varchar2(32) -- 创建部门
    ,create_time timestamp -- 创建时间
    ,update_user varchar2(20) -- 更新人
    ,update_time timestamp -- 更新时间
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
grant select on ${iol_schema}.fams_ban_bok_tax to ${iml_schema};
grant select on ${iol_schema}.fams_ban_bok_tax to ${icl_schema};
grant select on ${iol_schema}.fams_ban_bok_tax to ${idl_schema};
grant select on ${iol_schema}.fams_ban_bok_tax to ${iel_schema};

-- comment
comment on table ${iol_schema}.fams_ban_bok_tax is '增值税报表';
comment on column ${iol_schema}.fams_ban_bok_tax.cdate is '数据日期';
comment on column ${iol_schema}.fams_ban_bok_tax.org_no is '机构编号';
comment on column ${iol_schema}.fams_ban_bok_tax.org_name is '机构名称';
comment on column ${iol_schema}.fams_ban_bok_tax.ccy is '币种';
comment on column ${iol_schema}.fams_ban_bok_tax.subject_no is '科目编号';
comment on column ${iol_schema}.fams_ban_bok_tax.subject_name is '科目名称';
comment on column ${iol_schema}.fams_ban_bok_tax.prod_code is '产品';
comment on column ${iol_schema}.fams_ban_bok_tax.business is '业务场景';
comment on column ${iol_schema}.fams_ban_bok_tax.tax_type is '计税方法';
comment on column ${iol_schema}.fams_ban_bok_tax.tax_rate is '税率';
comment on column ${iol_schema}.fams_ban_bok_tax.tax_nature is '税目';
comment on column ${iol_schema}.fams_ban_bok_tax.tax_code is '免税代码';
comment on column ${iol_schema}.fams_ban_bok_tax.amount is '期间收入累计数';
comment on column ${iol_schema}.fams_ban_bok_tax.amt is '期间累计税额';
comment on column ${iol_schema}.fams_ban_bok_tax.bill_no is '发票号码';
comment on column ${iol_schema}.fams_ban_bok_tax.busi_id is '业务流水';
comment on column ${iol_schema}.fams_ban_bok_tax.source is '来源系统';
comment on column ${iol_schema}.fams_ban_bok_tax.create_user is '创建人';
comment on column ${iol_schema}.fams_ban_bok_tax.create_dept is '创建部门';
comment on column ${iol_schema}.fams_ban_bok_tax.create_time is '创建时间';
comment on column ${iol_schema}.fams_ban_bok_tax.update_user is '更新人';
comment on column ${iol_schema}.fams_ban_bok_tax.update_time is '更新时间';
comment on column ${iol_schema}.fams_ban_bok_tax.start_dt is '开始时间';
comment on column ${iol_schema}.fams_ban_bok_tax.end_dt is '结束时间';
comment on column ${iol_schema}.fams_ban_bok_tax.id_mark is '增删标志';
comment on column ${iol_schema}.fams_ban_bok_tax.etl_timestamp is 'ETL处理时间戳';
