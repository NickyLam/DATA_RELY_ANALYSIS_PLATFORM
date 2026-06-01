/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fams_fin_product
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fams_fin_product
whenever sqlerror continue none;
drop table ${iol_schema}.fams_fin_product purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_fin_product(
    finprod_id varchar2(50) -- 金融产品代码
    ,finprod_type varchar2(50) -- 金融产品类型（估值核算）
    ,finprod_type2 varchar2(50) -- 金融产品类型（投管分类）
    ,finprod_abbr varchar2(200) -- 金融产品简称
    ,finprod_name varchar2(200) -- 金融产品全称
    ,profit_type varchar2(50) -- 收益类型
    ,coupon_species varchar2(50) -- 息票品种
    ,chl_finprod_id varchar2(32) -- 通道代码
    ,finprod_market_id varchar2(50) -- 市场代码
    ,issue_id varchar2(32) -- 发行认购代码
    ,issue_price number(30,14) -- 发行价
    ,issue_amt number(30,2) -- 发行规模
    ,ccy varchar2(50) -- 币种
    ,bln_area varchar2(50) -- 境内外
    ,trade_market varchar2(50) -- 交易场所
    ,calendar_id varchar2(32) -- 交易日历
    ,issue_type varchar2(50) -- 发行方式/募集方式
    ,operation_type varchar2(50) -- 运作模式
    ,entrust_type varchar2(50) -- 委托方式
    ,entruster varchar2(2000) -- 委托方
    ,trustee_id varchar2(32) -- 托管人
    ,issuer varchar2(32) -- 发行人
    ,manager varchar2(32) -- 管理人
    ,financier varchar2(32) -- 融资人
    ,idate date -- 发行日
    ,vdate date -- 起息日
    ,mdate date -- 到期日
    ,term_days number(10) -- 期限天数
    ,actmdate date -- 实际到期日
    ,liquidation_date date -- 清盘日
    ,is_chl varchar2(50) -- 是否通道
    ,is_sus varchar2(50) -- 是否永续
    ,sustainable_remark varchar2(1000) -- 永续条款
    ,is_right varchar2(50) -- 是否含权
    ,capi_income_feature varchar2(50) -- 本金收益特征
    ,p_finprod_id varchar2(50) -- 母金融产品代码
    ,o_finprod_id varchar2(50) -- 原金融产品代码
    ,regist_org varchar2(50) -- 登记托管机构
    ,exe_date varchar2(50) -- 含权债摊销日
    ,remark varchar2(1000) -- 备注
    ,create_user varchar2(20) -- 创建人
    ,create_dept varchar2(32) -- 创建部门
    ,create_time timestamp -- 创建时间
    ,update_user varchar2(20) -- 更新人
    ,update_time timestamp -- 更新时间
    ,contract_no varchar2(500) -- 合同编号
    ,is_fin_org varchar2(50) -- 是否金融机构发行
    ,sponsor varchar2(32) -- 担保人
    ,invest_adviser varchar2(32) -- 投资顾问
    ,liquidation_yesno varchar2(50) -- 是否轧差清算
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by range(end_dt)(
    partition p_19000101 values less than (to_date('20991231','yyyymmdd'))
    ,partition p_20991231 values less than (maxvalue)
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.fams_fin_product to ${iml_schema};
grant select on ${iol_schema}.fams_fin_product to ${icl_schema};
grant select on ${iol_schema}.fams_fin_product to ${idl_schema};
grant select on ${iol_schema}.fams_fin_product to ${iel_schema};

-- comment
comment on table ${iol_schema}.fams_fin_product is '标的类金融产品';
comment on column ${iol_schema}.fams_fin_product.finprod_id is '金融产品代码';
comment on column ${iol_schema}.fams_fin_product.finprod_type is '金融产品类型（估值核算）';
comment on column ${iol_schema}.fams_fin_product.finprod_type2 is '金融产品类型（投管分类）';
comment on column ${iol_schema}.fams_fin_product.finprod_abbr is '金融产品简称';
comment on column ${iol_schema}.fams_fin_product.finprod_name is '金融产品全称';
comment on column ${iol_schema}.fams_fin_product.profit_type is '收益类型';
comment on column ${iol_schema}.fams_fin_product.coupon_species is '息票品种';
comment on column ${iol_schema}.fams_fin_product.chl_finprod_id is '通道代码';
comment on column ${iol_schema}.fams_fin_product.finprod_market_id is '市场代码';
comment on column ${iol_schema}.fams_fin_product.issue_id is '发行认购代码';
comment on column ${iol_schema}.fams_fin_product.issue_price is '发行价';
comment on column ${iol_schema}.fams_fin_product.issue_amt is '发行规模';
comment on column ${iol_schema}.fams_fin_product.ccy is '币种';
comment on column ${iol_schema}.fams_fin_product.bln_area is '境内外';
comment on column ${iol_schema}.fams_fin_product.trade_market is '交易场所';
comment on column ${iol_schema}.fams_fin_product.calendar_id is '交易日历';
comment on column ${iol_schema}.fams_fin_product.issue_type is '发行方式/募集方式';
comment on column ${iol_schema}.fams_fin_product.operation_type is '运作模式';
comment on column ${iol_schema}.fams_fin_product.entrust_type is '委托方式';
comment on column ${iol_schema}.fams_fin_product.entruster is '委托方';
comment on column ${iol_schema}.fams_fin_product.trustee_id is '托管人';
comment on column ${iol_schema}.fams_fin_product.issuer is '发行人';
comment on column ${iol_schema}.fams_fin_product.manager is '管理人';
comment on column ${iol_schema}.fams_fin_product.financier is '融资人';
comment on column ${iol_schema}.fams_fin_product.idate is '发行日';
comment on column ${iol_schema}.fams_fin_product.vdate is '起息日';
comment on column ${iol_schema}.fams_fin_product.mdate is '到期日';
comment on column ${iol_schema}.fams_fin_product.term_days is '期限天数';
comment on column ${iol_schema}.fams_fin_product.actmdate is '实际到期日';
comment on column ${iol_schema}.fams_fin_product.liquidation_date is '清盘日';
comment on column ${iol_schema}.fams_fin_product.is_chl is '是否通道';
comment on column ${iol_schema}.fams_fin_product.is_sus is '是否永续';
comment on column ${iol_schema}.fams_fin_product.sustainable_remark is '永续条款';
comment on column ${iol_schema}.fams_fin_product.is_right is '是否含权';
comment on column ${iol_schema}.fams_fin_product.capi_income_feature is '本金收益特征';
comment on column ${iol_schema}.fams_fin_product.p_finprod_id is '母金融产品代码';
comment on column ${iol_schema}.fams_fin_product.o_finprod_id is '原金融产品代码';
comment on column ${iol_schema}.fams_fin_product.regist_org is '登记托管机构';
comment on column ${iol_schema}.fams_fin_product.exe_date is '含权债摊销日';
comment on column ${iol_schema}.fams_fin_product.remark is '备注';
comment on column ${iol_schema}.fams_fin_product.create_user is '创建人';
comment on column ${iol_schema}.fams_fin_product.create_dept is '创建部门';
comment on column ${iol_schema}.fams_fin_product.create_time is '创建时间';
comment on column ${iol_schema}.fams_fin_product.update_user is '更新人';
comment on column ${iol_schema}.fams_fin_product.update_time is '更新时间';
comment on column ${iol_schema}.fams_fin_product.contract_no is '合同编号';
comment on column ${iol_schema}.fams_fin_product.is_fin_org is '是否金融机构发行';
comment on column ${iol_schema}.fams_fin_product.sponsor is '担保人';
comment on column ${iol_schema}.fams_fin_product.invest_adviser is '投资顾问';
comment on column ${iol_schema}.fams_fin_product.liquidation_yesno is '是否轧差清算';
comment on column ${iol_schema}.fams_fin_product.start_dt is '开始时间';
comment on column ${iol_schema}.fams_fin_product.end_dt is '结束时间';
comment on column ${iol_schema}.fams_fin_product.id_mark is '增删标志';
comment on column ${iol_schema}.fams_fin_product.etl_timestamp is 'ETL处理时间戳';
