/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_psp_cus_indiv
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_psp_cus_indiv
whenever sqlerror continue none;
drop table ${iol_schema}.icms_psp_cus_indiv purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_psp_cus_indiv(
    serialno varchar2(64) -- 流水号
    ,indivcomname varchar2(258) -- 工作单位
    ,indivcomfldname varchar2(400) -- 单位所属行业名称
    ,lastupddate varchar2(20) -- 最近更新日期
    ,comscale varchar2(6) -- 企业规模
    ,commrkflg varchar2(2) -- 是否上市
    ,customername varchar2(160) -- 客户名称
    ,mobile varchar2(35) -- 联系电话
    ,lastupdid varchar2(40) -- 最近更新人
    ,comname varchar2(160) -- 企业名称
    ,crdgrade varchar2(4) -- 本期信用等级
    ,indivhealst varchar2(2) -- 健康状况
    ,comtype varchar2(64) -- 所属行业
    ,personnum number(22) -- 家庭人口
    ,customerid varchar2(60) -- 客户号
    ,certcode varchar2(60) -- 证件号码
    ,indivcomfld varchar2(10) -- 单位所属行业
    ,postaddr varchar2(512) -- 通讯地址
    ,comgrpname varchar2(120) -- 所属集团
    ,cusstartdate varchar2(20) -- 首次建立信贷关系时间
    ,cusgrade varchar2(4) -- 客户评级
    ,indivcomjobttl varchar2(4) -- 职务
    ,comflg varchar2(2) -- 是否民营
    ,relativeserialno varchar2(128) -- 任务编号
    ,custype varchar2(10) -- 1-借款人，2-自然人，3-法人,4-专项检查,5、合作商
    ,indivmarst varchar2(4) -- 婚姻状况
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,modeltype varchar2(8) -- 产品类别
    ,indivocc varchar2(5) -- 职业
    ,certtype varchar2(4) -- 证件类型
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
grant select on ${iol_schema}.icms_psp_cus_indiv to ${iml_schema};
grant select on ${iol_schema}.icms_psp_cus_indiv to ${icl_schema};
grant select on ${iol_schema}.icms_psp_cus_indiv to ${idl_schema};
grant select on ${iol_schema}.icms_psp_cus_indiv to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_psp_cus_indiv is '贷后借款人基本情况';
comment on column ${iol_schema}.icms_psp_cus_indiv.serialno is '流水号';
comment on column ${iol_schema}.icms_psp_cus_indiv.indivcomname is '工作单位';
comment on column ${iol_schema}.icms_psp_cus_indiv.indivcomfldname is '单位所属行业名称';
comment on column ${iol_schema}.icms_psp_cus_indiv.lastupddate is '最近更新日期';
comment on column ${iol_schema}.icms_psp_cus_indiv.comscale is '企业规模';
comment on column ${iol_schema}.icms_psp_cus_indiv.commrkflg is '是否上市';
comment on column ${iol_schema}.icms_psp_cus_indiv.customername is '客户名称';
comment on column ${iol_schema}.icms_psp_cus_indiv.mobile is '联系电话';
comment on column ${iol_schema}.icms_psp_cus_indiv.lastupdid is '最近更新人';
comment on column ${iol_schema}.icms_psp_cus_indiv.comname is '企业名称';
comment on column ${iol_schema}.icms_psp_cus_indiv.crdgrade is '本期信用等级';
comment on column ${iol_schema}.icms_psp_cus_indiv.indivhealst is '健康状况';
comment on column ${iol_schema}.icms_psp_cus_indiv.comtype is '所属行业';
comment on column ${iol_schema}.icms_psp_cus_indiv.personnum is '家庭人口';
comment on column ${iol_schema}.icms_psp_cus_indiv.customerid is '客户号';
comment on column ${iol_schema}.icms_psp_cus_indiv.certcode is '证件号码';
comment on column ${iol_schema}.icms_psp_cus_indiv.indivcomfld is '单位所属行业';
comment on column ${iol_schema}.icms_psp_cus_indiv.postaddr is '通讯地址';
comment on column ${iol_schema}.icms_psp_cus_indiv.comgrpname is '所属集团';
comment on column ${iol_schema}.icms_psp_cus_indiv.cusstartdate is '首次建立信贷关系时间';
comment on column ${iol_schema}.icms_psp_cus_indiv.cusgrade is '客户评级';
comment on column ${iol_schema}.icms_psp_cus_indiv.indivcomjobttl is '职务';
comment on column ${iol_schema}.icms_psp_cus_indiv.comflg is '是否民营';
comment on column ${iol_schema}.icms_psp_cus_indiv.relativeserialno is '任务编号';
comment on column ${iol_schema}.icms_psp_cus_indiv.custype is '1-借款人，2-自然人，3-法人,4-专项检查,5、合作商';
comment on column ${iol_schema}.icms_psp_cus_indiv.indivmarst is '婚姻状况';
comment on column ${iol_schema}.icms_psp_cus_indiv.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_psp_cus_indiv.modeltype is '产品类别';
comment on column ${iol_schema}.icms_psp_cus_indiv.indivocc is '职业';
comment on column ${iol_schema}.icms_psp_cus_indiv.certtype is '证件类型';
comment on column ${iol_schema}.icms_psp_cus_indiv.start_dt is '开始时间';
comment on column ${iol_schema}.icms_psp_cus_indiv.end_dt is '结束时间';
comment on column ${iol_schema}.icms_psp_cus_indiv.id_mark is '增删标志';
comment on column ${iol_schema}.icms_psp_cus_indiv.etl_timestamp is 'ETL处理时间戳';
