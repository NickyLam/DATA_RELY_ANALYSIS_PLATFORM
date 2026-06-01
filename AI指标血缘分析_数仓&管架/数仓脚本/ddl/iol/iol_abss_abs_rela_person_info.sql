/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol abss_abs_rela_person_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.abss_abs_rela_person_info
whenever sqlerror continue none;
drop table ${iol_schema}.abss_abs_rela_person_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.abss_abs_rela_person_info(
    relapersonid varchar2(60) -- 关系人编号
    ,relapersonname varchar2(120) -- 关系人名称
    ,relapersontype varchar2(15) -- 关系人属性
    ,certtype varchar2(15) -- 证件类型
    ,certid varchar2(60) -- 证件号码
    ,issuecountry varchar2(60) -- 证件签发国家
    ,accountno varchar2(48) -- 账户号码
    ,accountname varchar2(300) -- 账户名称
    ,accountbank varchar2(48) -- 账户开户行
    ,largenumber varchar2(48) -- 大额行号
    ,largebankname varchar2(150) -- 大额行名称
    ,contact varchar2(150) -- 联系人
    ,contactway varchar2(48) -- 联系方式
    ,remark varchar2(383) -- 备注
    ,inputuserid varchar2(48) -- 登记人id
    ,inputorgid varchar2(48) -- 登记机构id
    ,inputdate varchar2(36) -- 登记日期id
    ,updateuserid varchar2(48) -- 更新人id
    ,updateorgid varchar2(48) -- 更新机构id
    ,updatedate varchar2(36) -- 更新日期
    ,tempsaveflag varchar2(15) -- 暂存标志
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
grant select on ${iol_schema}.abss_abs_rela_person_info to ${iml_schema};
grant select on ${iol_schema}.abss_abs_rela_person_info to ${icl_schema};
grant select on ${iol_schema}.abss_abs_rela_person_info to ${idl_schema};
grant select on ${iol_schema}.abss_abs_rela_person_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.abss_abs_rela_person_info is '关系人基本信息表';
comment on column ${iol_schema}.abss_abs_rela_person_info.relapersonid is '关系人编号';
comment on column ${iol_schema}.abss_abs_rela_person_info.relapersonname is '关系人名称';
comment on column ${iol_schema}.abss_abs_rela_person_info.relapersontype is '关系人属性';
comment on column ${iol_schema}.abss_abs_rela_person_info.certtype is '证件类型';
comment on column ${iol_schema}.abss_abs_rela_person_info.certid is '证件号码';
comment on column ${iol_schema}.abss_abs_rela_person_info.issuecountry is '证件签发国家';
comment on column ${iol_schema}.abss_abs_rela_person_info.accountno is '账户号码';
comment on column ${iol_schema}.abss_abs_rela_person_info.accountname is '账户名称';
comment on column ${iol_schema}.abss_abs_rela_person_info.accountbank is '账户开户行';
comment on column ${iol_schema}.abss_abs_rela_person_info.largenumber is '大额行号';
comment on column ${iol_schema}.abss_abs_rela_person_info.largebankname is '大额行名称';
comment on column ${iol_schema}.abss_abs_rela_person_info.contact is '联系人';
comment on column ${iol_schema}.abss_abs_rela_person_info.contactway is '联系方式';
comment on column ${iol_schema}.abss_abs_rela_person_info.remark is '备注';
comment on column ${iol_schema}.abss_abs_rela_person_info.inputuserid is '登记人id';
comment on column ${iol_schema}.abss_abs_rela_person_info.inputorgid is '登记机构id';
comment on column ${iol_schema}.abss_abs_rela_person_info.inputdate is '登记日期id';
comment on column ${iol_schema}.abss_abs_rela_person_info.updateuserid is '更新人id';
comment on column ${iol_schema}.abss_abs_rela_person_info.updateorgid is '更新机构id';
comment on column ${iol_schema}.abss_abs_rela_person_info.updatedate is '更新日期';
comment on column ${iol_schema}.abss_abs_rela_person_info.tempsaveflag is '暂存标志';
comment on column ${iol_schema}.abss_abs_rela_person_info.start_dt is '开始时间';
comment on column ${iol_schema}.abss_abs_rela_person_info.end_dt is '结束时间';
comment on column ${iol_schema}.abss_abs_rela_person_info.id_mark is '增删标志';
comment on column ${iol_schema}.abss_abs_rela_person_info.etl_timestamp is 'ETL处理时间戳';
