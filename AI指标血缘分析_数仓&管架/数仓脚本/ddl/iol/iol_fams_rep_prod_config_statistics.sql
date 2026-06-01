/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fams_rep_prod_config_statistics
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fams_rep_prod_config_statistics
whenever sqlerror continue none;
drop table ${iol_schema}.fams_rep_prod_config_statistics purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_rep_prod_config_statistics(
    cdate varchar2(50) -- 统计日
    ,accounttype varchar2(50) -- 账户类型
    ,prodcode varchar2(50) -- 理财账户ID
    ,prodname varchar2(200) -- 理财账户名称
    ,prodvdate varchar2(50) -- 产品起息日
    ,prodmdate varchar2(50) -- 产品到期日
    ,actprinamt number(30,14) -- 实收资本
    ,custrate varchar2(50) -- 客户收益率（%）
    ,assettype varchar2(50) -- 资产类型
    ,booktype varchar2(100) -- 会计分类
    ,assetcode varchar2(50) -- 资产代码
    ,assetname varchar2(200) -- 资产名称
    ,faceamt number(30,14) -- 面值
    ,netcost number(30,14) -- 买入净价成本
    ,intadjust number(30,14) -- 利息调整
    ,firstamt number(30,14) -- 首期结算金额
    ,expireamt number(30,14) -- 到期结算金额
    ,unpayamt1 number(30,14) -- 应收利息
    ,unpayamt2 number(30,14) -- 应计利息(零息券/到期一次还本)
    ,netvaluation number(30,14) -- 债券估值净价
    ,tdylossamt number(30,14) -- 资产减值金额
    ,fairvalue number(30,14) -- 公允价值变动
    ,facerate number(30,14) -- 票面利率(%)
    ,actrate number(30,14) -- 实际利率(%)
    ,reporate number(30,14) -- 回购利率(%)
    ,assetvdate varchar2(50) -- 资产起息日
    ,assetmdate varchar2(50) -- 资产到期日
    ,issueprice number(30,14) -- 发行价格
    ,intfrequency varchar2(50) -- 付息频率
    ,payfrequency varchar2(50) -- 还本频率
    ,lastpaydate varchar2(50) -- 上一付息日
    ,basis varchar2(50) -- 计息基础
    ,paystatus varchar2(50) -- 支付状态
    ,lastvdate varchar2(50) -- 上一计息起始日
    ,lastmdate varchar2(50) -- 上一计息结束日
    ,profittype varchar2(50) -- 收益类型
    ,assettypebeforeg60 varchar2(50) -- 资产分类（G06穿透前）
    ,assettypeafterg60 varchar2(50) -- 资产分类（G06穿透后）
    ,secyield number(30,14) -- 到期收益率(%)
    ,assettypeone varchar2(50) -- 资产一级分类
    ,assettypetwo varchar2(50) -- 资产二级分类
    ,assettypethree varchar2(50) -- 资产三级分类
    ,assttypefour varchar2(50) -- 资产四级分类
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.fams_rep_prod_config_statistics to ${iml_schema};
grant select on ${iol_schema}.fams_rep_prod_config_statistics to ${icl_schema};
grant select on ${iol_schema}.fams_rep_prod_config_statistics to ${idl_schema};
grant select on ${iol_schema}.fams_rep_prod_config_statistics to ${iel_schema};

-- comment
comment on table ${iol_schema}.fams_rep_prod_config_statistics is '产品配置情况统计表';
comment on column ${iol_schema}.fams_rep_prod_config_statistics.cdate is '统计日';
comment on column ${iol_schema}.fams_rep_prod_config_statistics.accounttype is '账户类型';
comment on column ${iol_schema}.fams_rep_prod_config_statistics.prodcode is '理财账户ID';
comment on column ${iol_schema}.fams_rep_prod_config_statistics.prodname is '理财账户名称';
comment on column ${iol_schema}.fams_rep_prod_config_statistics.prodvdate is '产品起息日';
comment on column ${iol_schema}.fams_rep_prod_config_statistics.prodmdate is '产品到期日';
comment on column ${iol_schema}.fams_rep_prod_config_statistics.actprinamt is '实收资本';
comment on column ${iol_schema}.fams_rep_prod_config_statistics.custrate is '客户收益率（%）';
comment on column ${iol_schema}.fams_rep_prod_config_statistics.assettype is '资产类型';
comment on column ${iol_schema}.fams_rep_prod_config_statistics.booktype is '会计分类';
comment on column ${iol_schema}.fams_rep_prod_config_statistics.assetcode is '资产代码';
comment on column ${iol_schema}.fams_rep_prod_config_statistics.assetname is '资产名称';
comment on column ${iol_schema}.fams_rep_prod_config_statistics.faceamt is '面值';
comment on column ${iol_schema}.fams_rep_prod_config_statistics.netcost is '买入净价成本';
comment on column ${iol_schema}.fams_rep_prod_config_statistics.intadjust is '利息调整';
comment on column ${iol_schema}.fams_rep_prod_config_statistics.firstamt is '首期结算金额';
comment on column ${iol_schema}.fams_rep_prod_config_statistics.expireamt is '到期结算金额';
comment on column ${iol_schema}.fams_rep_prod_config_statistics.unpayamt1 is '应收利息';
comment on column ${iol_schema}.fams_rep_prod_config_statistics.unpayamt2 is '应计利息(零息券/到期一次还本)';
comment on column ${iol_schema}.fams_rep_prod_config_statistics.netvaluation is '债券估值净价';
comment on column ${iol_schema}.fams_rep_prod_config_statistics.tdylossamt is '资产减值金额';
comment on column ${iol_schema}.fams_rep_prod_config_statistics.fairvalue is '公允价值变动';
comment on column ${iol_schema}.fams_rep_prod_config_statistics.facerate is '票面利率(%)';
comment on column ${iol_schema}.fams_rep_prod_config_statistics.actrate is '实际利率(%)';
comment on column ${iol_schema}.fams_rep_prod_config_statistics.reporate is '回购利率(%)';
comment on column ${iol_schema}.fams_rep_prod_config_statistics.assetvdate is '资产起息日';
comment on column ${iol_schema}.fams_rep_prod_config_statistics.assetmdate is '资产到期日';
comment on column ${iol_schema}.fams_rep_prod_config_statistics.issueprice is '发行价格';
comment on column ${iol_schema}.fams_rep_prod_config_statistics.intfrequency is '付息频率';
comment on column ${iol_schema}.fams_rep_prod_config_statistics.payfrequency is '还本频率';
comment on column ${iol_schema}.fams_rep_prod_config_statistics.lastpaydate is '上一付息日';
comment on column ${iol_schema}.fams_rep_prod_config_statistics.basis is '计息基础';
comment on column ${iol_schema}.fams_rep_prod_config_statistics.paystatus is '支付状态';
comment on column ${iol_schema}.fams_rep_prod_config_statistics.lastvdate is '上一计息起始日';
comment on column ${iol_schema}.fams_rep_prod_config_statistics.lastmdate is '上一计息结束日';
comment on column ${iol_schema}.fams_rep_prod_config_statistics.profittype is '收益类型';
comment on column ${iol_schema}.fams_rep_prod_config_statistics.assettypebeforeg60 is '资产分类（G06穿透前）';
comment on column ${iol_schema}.fams_rep_prod_config_statistics.assettypeafterg60 is '资产分类（G06穿透后）';
comment on column ${iol_schema}.fams_rep_prod_config_statistics.secyield is '到期收益率(%)';
comment on column ${iol_schema}.fams_rep_prod_config_statistics.assettypeone is '资产一级分类';
comment on column ${iol_schema}.fams_rep_prod_config_statistics.assettypetwo is '资产二级分类';
comment on column ${iol_schema}.fams_rep_prod_config_statistics.assettypethree is '资产三级分类';
comment on column ${iol_schema}.fams_rep_prod_config_statistics.assttypefour is '资产四级分类';
comment on column ${iol_schema}.fams_rep_prod_config_statistics.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.fams_rep_prod_config_statistics.etl_timestamp is 'ETL处理时间戳';
