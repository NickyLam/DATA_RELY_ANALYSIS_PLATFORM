/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_si_bondcompany
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_si_bondcompany
whenever sqlerror continue none;
drop table ${iol_schema}.mims_si_bondcompany purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_bondcompany(
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
    ,isstage varchar2(3) -- 是否阶段性担保
    ,guarcash number(20,2) -- 担保公司保证金金额
    ,remark varchar2(4000) -- 其他说明
    ,guarprice number(20,2) -- 担保总额度
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
grant select on ${iol_schema}.mims_si_bondcompany to ${iml_schema};
grant select on ${iol_schema}.mims_si_bondcompany to ${icl_schema};
grant select on ${iol_schema}.mims_si_bondcompany to ${idl_schema};
grant select on ${iol_schema}.mims_si_bondcompany to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_si_bondcompany is '担保公司保证';
comment on column ${iol_schema}.mims_si_bondcompany.sccode is '押品编号';
comment on column ${iol_schema}.mims_si_bondcompany.vouchertype is '保证人类型';
comment on column ${iol_schema}.mims_si_bondcompany.voucherno is '保证人编号';
comment on column ${iol_schema}.mims_si_bondcompany.vouchername is '保证人名称';
comment on column ${iol_schema}.mims_si_bondcompany.cardno is '保证人组织机构代码';
comment on column ${iol_schema}.mims_si_bondcompany.industry is '保证人国标行业分类';
comment on column ${iol_schema}.mims_si_bondcompany.netasset is '保证人净资产';
comment on column ${iol_schema}.mims_si_bondcompany.economic is '保证人经济成分';
comment on column ${iol_schema}.mims_si_bondcompany.independence is '保证人担保独立性';
comment on column ${iol_schema}.mims_si_bondcompany.registcountry is '保证人注册地所在国家或地区';
comment on column ${iol_schema}.mims_si_bondcompany.registcountryresult is '保证人注册地所在国家或地区外部评级结果';
comment on column ${iol_schema}.mims_si_bondcompany.outratingdate is '保证人外部评级日期';
comment on column ${iol_schema}.mims_si_bondcompany.outratingresult is '保证人外部评级结果';
comment on column ${iol_schema}.mims_si_bondcompany.inratingdate is '保证人内部评级日期';
comment on column ${iol_schema}.mims_si_bondcompany.inratingresult is '保证人内部评级结果';
comment on column ${iol_schema}.mims_si_bondcompany.purpose is '保证目的';
comment on column ${iol_schema}.mims_si_bondcompany.isstage is '是否阶段性担保';
comment on column ${iol_schema}.mims_si_bondcompany.guarcash is '担保公司保证金金额';
comment on column ${iol_schema}.mims_si_bondcompany.remark is '其他说明';
comment on column ${iol_schema}.mims_si_bondcompany.guarprice is '担保总额度';
comment on column ${iol_schema}.mims_si_bondcompany.tdcurrency is '币种';
comment on column ${iol_schema}.mims_si_bondcompany.isresident is '是否居民';
comment on column ${iol_schema}.mims_si_bondcompany.cardtype is '证件类型';
comment on column ${iol_schema}.mims_si_bondcompany.start_dt is '开始时间';
comment on column ${iol_schema}.mims_si_bondcompany.end_dt is '结束时间';
comment on column ${iol_schema}.mims_si_bondcompany.id_mark is '增删标志';
comment on column ${iol_schema}.mims_si_bondcompany.etl_timestamp is 'ETL处理时间戳';
