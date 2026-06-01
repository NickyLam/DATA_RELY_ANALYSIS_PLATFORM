/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_si_guarinsurance
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_si_guarinsurance
whenever sqlerror continue none;
drop table ${iol_schema}.mims_si_guarinsurance purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_guarinsurance(
    sccode varchar2(48) -- 押品编号
    ,vouchertype varchar2(3) -- 保证人类型
    ,voucherno varchar2(90) -- 保证人编号
    ,vouchername varchar2(150) -- 保证人名称
    ,cardno varchar2(90) -- 保证人组织机构代码
    ,industry varchar2(150) -- 保证人国标行业分类
    ,netasset number(20,2) -- 保证人净资产
    ,economic varchar2(3) -- 保证人经济成分
    ,independence varchar2(3) -- 保证人担保独立性
    ,registcountry varchar2(150) -- 保证人注册地所在国家或地区
    ,registcountryresult varchar2(150) -- 保证人注册地所在国家或地区外部评级结果
    ,outratingdate varchar2(15) -- 保证人外部评级日期
    ,outratingresult varchar2(150) -- 保证人外部评级结果
    ,inratingdate varchar2(15) -- 保证人内部评级日期
    ,inratingresult varchar2(150) -- 保证人内部评级结果
    ,purpose varchar2(3) -- 保证目的
    ,insuranceno varchar2(90) -- 保证保险保单号码
    ,isstage varchar2(3) -- 是否阶段性担保
    ,remark varchar2(4000) -- 其他说明
    ,tdcurrency varchar2(5) -- 币种
    ,isresident varchar2(3) -- 是否居民
    ,cardtype varchar2(10) -- 证件类型
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
grant select on ${iol_schema}.mims_si_guarinsurance to ${iml_schema};
grant select on ${iol_schema}.mims_si_guarinsurance to ${icl_schema};
grant select on ${iol_schema}.mims_si_guarinsurance to ${idl_schema};
grant select on ${iol_schema}.mims_si_guarinsurance to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_si_guarinsurance is '保证保险';
comment on column ${iol_schema}.mims_si_guarinsurance.sccode is '押品编号';
comment on column ${iol_schema}.mims_si_guarinsurance.vouchertype is '保证人类型';
comment on column ${iol_schema}.mims_si_guarinsurance.voucherno is '保证人编号';
comment on column ${iol_schema}.mims_si_guarinsurance.vouchername is '保证人名称';
comment on column ${iol_schema}.mims_si_guarinsurance.cardno is '保证人组织机构代码';
comment on column ${iol_schema}.mims_si_guarinsurance.industry is '保证人国标行业分类';
comment on column ${iol_schema}.mims_si_guarinsurance.netasset is '保证人净资产';
comment on column ${iol_schema}.mims_si_guarinsurance.economic is '保证人经济成分';
comment on column ${iol_schema}.mims_si_guarinsurance.independence is '保证人担保独立性';
comment on column ${iol_schema}.mims_si_guarinsurance.registcountry is '保证人注册地所在国家或地区';
comment on column ${iol_schema}.mims_si_guarinsurance.registcountryresult is '保证人注册地所在国家或地区外部评级结果';
comment on column ${iol_schema}.mims_si_guarinsurance.outratingdate is '保证人外部评级日期';
comment on column ${iol_schema}.mims_si_guarinsurance.outratingresult is '保证人外部评级结果';
comment on column ${iol_schema}.mims_si_guarinsurance.inratingdate is '保证人内部评级日期';
comment on column ${iol_schema}.mims_si_guarinsurance.inratingresult is '保证人内部评级结果';
comment on column ${iol_schema}.mims_si_guarinsurance.purpose is '保证目的';
comment on column ${iol_schema}.mims_si_guarinsurance.insuranceno is '保证保险保单号码';
comment on column ${iol_schema}.mims_si_guarinsurance.isstage is '是否阶段性担保';
comment on column ${iol_schema}.mims_si_guarinsurance.remark is '其他说明';
comment on column ${iol_schema}.mims_si_guarinsurance.tdcurrency is '币种';
comment on column ${iol_schema}.mims_si_guarinsurance.isresident is '是否居民';
comment on column ${iol_schema}.mims_si_guarinsurance.cardtype is '证件类型';
comment on column ${iol_schema}.mims_si_guarinsurance.start_dt is '开始时间';
comment on column ${iol_schema}.mims_si_guarinsurance.end_dt is '结束时间';
comment on column ${iol_schema}.mims_si_guarinsurance.id_mark is '增删标志';
comment on column ${iol_schema}.mims_si_guarinsurance.etl_timestamp is 'ETL处理时间戳';
