/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_ent_bondissue
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_ent_bondissue
whenever sqlerror continue none;
drop table ${iol_schema}.icms_ent_bondissue purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ent_bondissue(
    serialno varchar2(64) -- 流水号
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,bondseller varchar2(160) -- 债券承销商
    ,bondsum number(24,6) -- 发行金额
    ,updatedate date -- 更新日期
    ,bondname varchar2(160) -- 债券名称
    ,irregulation varchar2(1000) -- 利率规定
    ,bondterm number(22) -- 债券期限
    ,bondwarrantor varchar2(160) -- 债券主担保人
    ,bondgrade varchar2(36) -- 债券级别
    ,updateorgid varchar2(64) -- 更新机构
    ,corporgid varchar2(64) -- 法人机构编号
    ,boursename varchar2(160) -- 上市交易所名称
    ,inputuserid varchar2(64) -- 登记人
    ,bondcurrency varchar2(3) -- 发行币种
    ,companytype varchar2(36) -- 上市公司类型
    ,inputorgid varchar2(64) -- 登记机构
    ,bondtype varchar2(2) -- 债券类型
    ,marketedornot varchar2(2) -- 是否上市
    ,updateuserid varchar2(64) -- 更新人
    ,customerid varchar2(16) -- 客户编号
    ,issuedate date -- 发行时间
    ,remark varchar2(1000) -- 备注
    ,inputdate date -- 登记日期
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
grant select on ${iol_schema}.icms_ent_bondissue to ${iml_schema};
grant select on ${iol_schema}.icms_ent_bondissue to ${icl_schema};
grant select on ${iol_schema}.icms_ent_bondissue to ${idl_schema};
grant select on ${iol_schema}.icms_ent_bondissue to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_ent_bondissue is '企业发行债券信息企业发行债券信息';
comment on column ${iol_schema}.icms_ent_bondissue.serialno is '流水号';
comment on column ${iol_schema}.icms_ent_bondissue.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_ent_bondissue.bondseller is '债券承销商';
comment on column ${iol_schema}.icms_ent_bondissue.bondsum is '发行金额';
comment on column ${iol_schema}.icms_ent_bondissue.updatedate is '更新日期';
comment on column ${iol_schema}.icms_ent_bondissue.bondname is '债券名称';
comment on column ${iol_schema}.icms_ent_bondissue.irregulation is '利率规定';
comment on column ${iol_schema}.icms_ent_bondissue.bondterm is '债券期限';
comment on column ${iol_schema}.icms_ent_bondissue.bondwarrantor is '债券主担保人';
comment on column ${iol_schema}.icms_ent_bondissue.bondgrade is '债券级别';
comment on column ${iol_schema}.icms_ent_bondissue.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_ent_bondissue.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_ent_bondissue.boursename is '上市交易所名称';
comment on column ${iol_schema}.icms_ent_bondissue.inputuserid is '登记人';
comment on column ${iol_schema}.icms_ent_bondissue.bondcurrency is '发行币种';
comment on column ${iol_schema}.icms_ent_bondissue.companytype is '上市公司类型';
comment on column ${iol_schema}.icms_ent_bondissue.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_ent_bondissue.bondtype is '债券类型';
comment on column ${iol_schema}.icms_ent_bondissue.marketedornot is '是否上市';
comment on column ${iol_schema}.icms_ent_bondissue.updateuserid is '更新人';
comment on column ${iol_schema}.icms_ent_bondissue.customerid is '客户编号';
comment on column ${iol_schema}.icms_ent_bondissue.issuedate is '发行时间';
comment on column ${iol_schema}.icms_ent_bondissue.remark is '备注';
comment on column ${iol_schema}.icms_ent_bondissue.inputdate is '登记日期';
comment on column ${iol_schema}.icms_ent_bondissue.start_dt is '开始时间';
comment on column ${iol_schema}.icms_ent_bondissue.end_dt is '结束时间';
comment on column ${iol_schema}.icms_ent_bondissue.id_mark is '增删标志';
comment on column ${iol_schema}.icms_ent_bondissue.etl_timestamp is 'ETL处理时间戳';
