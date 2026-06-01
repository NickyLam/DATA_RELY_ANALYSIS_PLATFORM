/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol abss_abs_product_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.abss_abs_product_info
whenever sqlerror continue none;
drop table ${iol_schema}.abss_abs_product_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.abss_abs_product_info(
    productid varchar2(60) -- 产品编号
    ,productname varchar2(150) -- 产品名称
    ,producttype varchar2(15) -- 产品类型
    ,productstatus varchar2(27) -- 产品状态
    ,businessstatus varchar2(3) -- 产品业务状态
    ,productmodel varchar2(27) -- 产品模式
    ,preamt number(24,2) -- 预发行总额
    ,assetamt number(24,2) -- 资产总额
    ,confirmamt number(24,2) -- 确认发行总额
    ,currency varchar2(27) -- 币种
    ,repurchaseflag varchar2(2) -- 是否支持清仓回购
    ,itemno varchar2(60) -- 项目编号
    ,assetpoolno varchar2(60) -- 资产池编号
    ,initialdate varchar2(36) -- 初始起算日/封包日
    ,trustdate varchar2(36) -- 信托生效日/信托设立日
    ,maturity varchar2(36) -- 信托法定到期日
    ,creditmeasure varchar2(15) -- 增信措施
    ,bookbuildingdate varchar2(36) -- 簿记建档日/发行日
    ,deliverydate varchar2(36) -- 信托财产交付日
    ,finishtype varchar2(15) -- 终结类型
    ,finishdate varchar2(36) -- 终结日期
    ,paygracedays number(10,0) -- 转付偏移天数
    ,tempsaveflag varchar2(2) -- 暂存标识(0-保存,1-暂存)
    ,remark varchar2(383) -- 备注
    ,inputuserid varchar2(48) -- 登记人id
    ,inputorgid varchar2(48) -- 登记机构id
    ,inputtime varchar2(36) -- 登记时间
    ,updatetime varchar2(36) -- 更新时间
    ,paydaterule varchar2(60) -- 
    ,lossrate number(24,6) -- 违约率
    ,prepayrate number(24,6) -- 早偿率
    ,overduerate number(24,6) -- 逾期率
    ,pretenlossrate number(24,6) -- 前十大资产违约率
    ,cashflowflag varchar2(15) -- 现金流测算标识
    ,creditremark varchar2(300) -- 征信措施备注
    ,assettransferamt number(24,6) -- 资产转让对价
    ,assettransferamttype varchar2(30) -- 资产转让对价计算方式
    ,zrhth varchar2(150) -- 转让合同号
    ,zrsxf number(20,2) -- 转让手续费
    ,hgll number(10,6) -- 回购利率
    ,zrhtqsrq varchar2(36) -- 转让合同起始日期
    ,zrhtdqrq varchar2(36) -- 转让合同到期日期
    ,isdiycycle varchar2(3) -- 是否为自定义归集周期
    ,platform varchar2(15) -- 
    ,transactionorgtype varchar2(15) -- 
    ,updatefeeplan varchar2(15) -- 是否更新费用计划
    ,transferdate varchar2(15) -- 交易对手转账日期
    ,paidamt number(24,2) -- 交易对手已支付金额
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
grant select on ${iol_schema}.abss_abs_product_info to ${iml_schema};
grant select on ${iol_schema}.abss_abs_product_info to ${icl_schema};
grant select on ${iol_schema}.abss_abs_product_info to ${idl_schema};
grant select on ${iol_schema}.abss_abs_product_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.abss_abs_product_info is '产品基本信息表';
comment on column ${iol_schema}.abss_abs_product_info.productid is '产品编号';
comment on column ${iol_schema}.abss_abs_product_info.productname is '产品名称';
comment on column ${iol_schema}.abss_abs_product_info.producttype is '产品类型';
comment on column ${iol_schema}.abss_abs_product_info.productstatus is '产品状态';
comment on column ${iol_schema}.abss_abs_product_info.businessstatus is '产品业务状态';
comment on column ${iol_schema}.abss_abs_product_info.productmodel is '产品模式';
comment on column ${iol_schema}.abss_abs_product_info.preamt is '预发行总额';
comment on column ${iol_schema}.abss_abs_product_info.assetamt is '资产总额';
comment on column ${iol_schema}.abss_abs_product_info.confirmamt is '确认发行总额';
comment on column ${iol_schema}.abss_abs_product_info.currency is '币种';
comment on column ${iol_schema}.abss_abs_product_info.repurchaseflag is '是否支持清仓回购';
comment on column ${iol_schema}.abss_abs_product_info.itemno is '项目编号';
comment on column ${iol_schema}.abss_abs_product_info.assetpoolno is '资产池编号';
comment on column ${iol_schema}.abss_abs_product_info.initialdate is '初始起算日/封包日';
comment on column ${iol_schema}.abss_abs_product_info.trustdate is '信托生效日/信托设立日';
comment on column ${iol_schema}.abss_abs_product_info.maturity is '信托法定到期日';
comment on column ${iol_schema}.abss_abs_product_info.creditmeasure is '增信措施';
comment on column ${iol_schema}.abss_abs_product_info.bookbuildingdate is '簿记建档日/发行日';
comment on column ${iol_schema}.abss_abs_product_info.deliverydate is '信托财产交付日';
comment on column ${iol_schema}.abss_abs_product_info.finishtype is '终结类型';
comment on column ${iol_schema}.abss_abs_product_info.finishdate is '终结日期';
comment on column ${iol_schema}.abss_abs_product_info.paygracedays is '转付偏移天数';
comment on column ${iol_schema}.abss_abs_product_info.tempsaveflag is '暂存标识(0-保存,1-暂存)';
comment on column ${iol_schema}.abss_abs_product_info.remark is '备注';
comment on column ${iol_schema}.abss_abs_product_info.inputuserid is '登记人id';
comment on column ${iol_schema}.abss_abs_product_info.inputorgid is '登记机构id';
comment on column ${iol_schema}.abss_abs_product_info.inputtime is '登记时间';
comment on column ${iol_schema}.abss_abs_product_info.updatetime is '更新时间';
comment on column ${iol_schema}.abss_abs_product_info.paydaterule is '';
comment on column ${iol_schema}.abss_abs_product_info.lossrate is '违约率';
comment on column ${iol_schema}.abss_abs_product_info.prepayrate is '早偿率';
comment on column ${iol_schema}.abss_abs_product_info.overduerate is '逾期率';
comment on column ${iol_schema}.abss_abs_product_info.pretenlossrate is '前十大资产违约率';
comment on column ${iol_schema}.abss_abs_product_info.cashflowflag is '现金流测算标识';
comment on column ${iol_schema}.abss_abs_product_info.creditremark is '征信措施备注';
comment on column ${iol_schema}.abss_abs_product_info.assettransferamt is '资产转让对价';
comment on column ${iol_schema}.abss_abs_product_info.assettransferamttype is '资产转让对价计算方式';
comment on column ${iol_schema}.abss_abs_product_info.zrhth is '转让合同号';
comment on column ${iol_schema}.abss_abs_product_info.zrsxf is '转让手续费';
comment on column ${iol_schema}.abss_abs_product_info.hgll is '回购利率';
comment on column ${iol_schema}.abss_abs_product_info.zrhtqsrq is '转让合同起始日期';
comment on column ${iol_schema}.abss_abs_product_info.zrhtdqrq is '转让合同到期日期';
comment on column ${iol_schema}.abss_abs_product_info.isdiycycle is '是否为自定义归集周期';
comment on column ${iol_schema}.abss_abs_product_info.platform is '';
comment on column ${iol_schema}.abss_abs_product_info.transactionorgtype is '';
comment on column ${iol_schema}.abss_abs_product_info.updatefeeplan is '是否更新费用计划';
comment on column ${iol_schema}.abss_abs_product_info.transferdate is '交易对手转账日期';
comment on column ${iol_schema}.abss_abs_product_info.paidamt is '交易对手已支付金额';
comment on column ${iol_schema}.abss_abs_product_info.start_dt is '开始时间';
comment on column ${iol_schema}.abss_abs_product_info.end_dt is '结束时间';
comment on column ${iol_schema}.abss_abs_product_info.id_mark is '增删标志';
comment on column ${iol_schema}.abss_abs_product_info.etl_timestamp is 'ETL处理时间戳';
