/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_code_catalog
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_code_catalog
whenever sqlerror continue none;
drop table ${iol_schema}.icms_code_catalog purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_code_catalog(
    codeno varchar2(64) -- 代码编号
    ,codetypetwo varchar2(160) -- 代码小类
    ,updateuser varchar2(64) -- 更新人
    ,codetypeone varchar2(160) -- 代码大类
    ,codeattribute varchar2(1000) -- 代码属性
    ,updateorg varchar2(64) -- 更新机构
    ,inputorg varchar2(64) -- 登记机构
    ,sortno varchar2(64) -- 排序号
    ,remark varchar2(1000) -- 备注
    ,updatedate date -- 更新日期
    ,inputtime varchar2(64) -- 登记时间
    ,updatetime varchar2(64) -- 更新时间
    ,codename varchar2(160) -- 代码名称
    ,codedescribe varchar2(1000) -- 代码描述
    ,inputdate date -- 登记日期
    ,inputuser varchar2(64) -- 登记人
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
grant select on ${iol_schema}.icms_code_catalog to ${iml_schema};
grant select on ${iol_schema}.icms_code_catalog to ${icl_schema};
grant select on ${iol_schema}.icms_code_catalog to ${idl_schema};
grant select on ${iol_schema}.icms_code_catalog to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_code_catalog is '代码类别表代码类别表';
comment on column ${iol_schema}.icms_code_catalog.codeno is '代码编号';
comment on column ${iol_schema}.icms_code_catalog.codetypetwo is '代码小类';
comment on column ${iol_schema}.icms_code_catalog.updateuser is '更新人';
comment on column ${iol_schema}.icms_code_catalog.codetypeone is '代码大类';
comment on column ${iol_schema}.icms_code_catalog.codeattribute is '代码属性';
comment on column ${iol_schema}.icms_code_catalog.updateorg is '更新机构';
comment on column ${iol_schema}.icms_code_catalog.inputorg is '登记机构';
comment on column ${iol_schema}.icms_code_catalog.sortno is '排序号';
comment on column ${iol_schema}.icms_code_catalog.remark is '备注';
comment on column ${iol_schema}.icms_code_catalog.updatedate is '更新日期';
comment on column ${iol_schema}.icms_code_catalog.inputtime is '登记时间';
comment on column ${iol_schema}.icms_code_catalog.updatetime is '更新时间';
comment on column ${iol_schema}.icms_code_catalog.codename is '代码名称';
comment on column ${iol_schema}.icms_code_catalog.codedescribe is '代码描述';
comment on column ${iol_schema}.icms_code_catalog.inputdate is '登记日期';
comment on column ${iol_schema}.icms_code_catalog.inputuser is '登记人';
comment on column ${iol_schema}.icms_code_catalog.start_dt is '开始时间';
comment on column ${iol_schema}.icms_code_catalog.end_dt is '结束时间';
comment on column ${iol_schema}.icms_code_catalog.id_mark is '增删标志';
comment on column ${iol_schema}.icms_code_catalog.etl_timestamp is 'ETL处理时间戳';
