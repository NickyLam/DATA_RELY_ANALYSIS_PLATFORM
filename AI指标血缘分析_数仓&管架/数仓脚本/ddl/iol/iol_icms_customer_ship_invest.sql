/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_customer_ship_invest
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_customer_ship_invest
whenever sqlerror continue none;
drop table ${iol_schema}.icms_customer_ship_invest purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_customer_ship_invest(
    serialno varchar2(64) -- 流水号
    ,certid varchar2(32) -- 投向企业证件号码
    ,remark varchar2(500) -- 备注
    ,indname varchar2(80) -- 投向企业法人代表名称
    ,updatedate date -- 更新日期
    ,customername varchar2(200) -- 投向企业姓名
    ,certtype varchar2(4) -- 投向企业证件类型
    ,oughtsum number(24,6) -- 出资金额
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,inputuserid varchar2(32) -- 登记人
    ,updateuserid varchar2(32) -- 更新人
    ,loancardno varchar2(32) -- 投向企业贷款卡编号
    ,maincustomerid varchar2(32) -- 主客户号
    ,investmentprop number(24,8) -- 出资比例
    ,inputorgid varchar2(32) -- 登记机构
    ,corporgid varchar2(32) -- 法人机构编号
    ,customerid varchar2(30) -- 客户编号
    ,enttype varchar2(18) -- 企业类型
    ,relationship varchar2(80) -- 投资方式
    ,updateorgid varchar2(32) -- 更新机构
    ,firstearnings number(24,6) -- 第一年投资收益
    ,creditinstitutioncode varchar2(18) -- 机构信用代码
    ,customertype varchar2(18) -- 投向企业类型
    ,relationstate varchar2(18) -- 投资情况
    ,investdate date -- 投资日期
    ,relatetype varchar2(3) -- 关联类型
    ,tempstatus varchar2(1) -- 暂存状态
    ,currency varchar2(18) -- 出资币种
    ,investmentsum number(24,6) -- 实际投资金额
    ,inputdate date -- 登记日期
    ,migtoldvalue varchar2(250) -- 备份原字段值
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
grant select on ${iol_schema}.icms_customer_ship_invest to ${iml_schema};
grant select on ${iol_schema}.icms_customer_ship_invest to ${icl_schema};
grant select on ${iol_schema}.icms_customer_ship_invest to ${idl_schema};
grant select on ${iol_schema}.icms_customer_ship_invest to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_customer_ship_invest is '客户投资信息';
comment on column ${iol_schema}.icms_customer_ship_invest.serialno is '流水号';
comment on column ${iol_schema}.icms_customer_ship_invest.certid is '投向企业证件号码';
comment on column ${iol_schema}.icms_customer_ship_invest.remark is '备注';
comment on column ${iol_schema}.icms_customer_ship_invest.indname is '投向企业法人代表名称';
comment on column ${iol_schema}.icms_customer_ship_invest.updatedate is '更新日期';
comment on column ${iol_schema}.icms_customer_ship_invest.customername is '投向企业姓名';
comment on column ${iol_schema}.icms_customer_ship_invest.certtype is '投向企业证件类型';
comment on column ${iol_schema}.icms_customer_ship_invest.oughtsum is '出资金额';
comment on column ${iol_schema}.icms_customer_ship_invest.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_customer_ship_invest.inputuserid is '登记人';
comment on column ${iol_schema}.icms_customer_ship_invest.updateuserid is '更新人';
comment on column ${iol_schema}.icms_customer_ship_invest.loancardno is '投向企业贷款卡编号';
comment on column ${iol_schema}.icms_customer_ship_invest.maincustomerid is '主客户号';
comment on column ${iol_schema}.icms_customer_ship_invest.investmentprop is '出资比例';
comment on column ${iol_schema}.icms_customer_ship_invest.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_customer_ship_invest.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_customer_ship_invest.customerid is '客户编号';
comment on column ${iol_schema}.icms_customer_ship_invest.enttype is '企业类型';
comment on column ${iol_schema}.icms_customer_ship_invest.relationship is '投资方式';
comment on column ${iol_schema}.icms_customer_ship_invest.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_customer_ship_invest.firstearnings is '第一年投资收益';
comment on column ${iol_schema}.icms_customer_ship_invest.creditinstitutioncode is '机构信用代码';
comment on column ${iol_schema}.icms_customer_ship_invest.customertype is '投向企业类型';
comment on column ${iol_schema}.icms_customer_ship_invest.relationstate is '投资情况';
comment on column ${iol_schema}.icms_customer_ship_invest.investdate is '投资日期';
comment on column ${iol_schema}.icms_customer_ship_invest.relatetype is '关联类型';
comment on column ${iol_schema}.icms_customer_ship_invest.tempstatus is '暂存状态';
comment on column ${iol_schema}.icms_customer_ship_invest.currency is '出资币种';
comment on column ${iol_schema}.icms_customer_ship_invest.investmentsum is '实际投资金额';
comment on column ${iol_schema}.icms_customer_ship_invest.inputdate is '登记日期';
comment on column ${iol_schema}.icms_customer_ship_invest.migtoldvalue is '备份原字段值';
comment on column ${iol_schema}.icms_customer_ship_invest.start_dt is '开始时间';
comment on column ${iol_schema}.icms_customer_ship_invest.end_dt is '结束时间';
comment on column ${iol_schema}.icms_customer_ship_invest.id_mark is '增删标志';
comment on column ${iol_schema}.icms_customer_ship_invest.etl_timestamp is 'ETL处理时间戳';
