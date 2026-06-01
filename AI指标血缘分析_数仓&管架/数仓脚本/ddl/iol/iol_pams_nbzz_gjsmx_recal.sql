/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_nbzz_gjsmx_recal
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_nbzz_gjsmx_recal
whenever sqlerror continue none;
drop table ${iol_schema}.pams_nbzz_gjsmx_recal purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_nbzz_gjsmx_recal(
    recal_dt number(38,0) -- 重算窗口日期
    ,tjrq number(38,0) -- 统计日期
    ,jxdxdh number(38,0) -- 绩效对象代号
    ,khh varchar2(300) -- 客户号
    ,jgdh varchar2(300) -- 机构代号
    ,khdxdh number(38,0) -- 考核对象代号
    ,jgkhdxdh number(38,0) -- 机构考核对象代号
    ,bz varchar2(9) -- 币种
    ,fpjs varchar2(6) -- 分配角色
    ,zlbl number(19,5) -- 增量比例
    ,ddh varchar2(96) -- 行内订单号
    ,yhlsh varchar2(750) -- 银行流水号
    ,jyrq number(38,0) -- 交易日期
    ,ddrq number(38,0) -- 订单日期
    ,khmc varchar2(1500) -- 客户名称
    ,cph varchar2(750) -- 产品号
    ,cpmc varchar2(2250) -- 产品名称
    ,cpcs varchar2(90) -- 产品成色
    ,hjl varchar2(90) -- 含金量
    ,hyl varchar2(90) -- 含银量
    ,gmsl varchar2(90) -- 购买数量
    ,gysmc varchar2(1500) -- 供应商名称
    ,xsqd varchar2(90) -- 销售渠道
    ,jydj number(22,6) -- 交易单价
    ,zhye number(22,6) -- 账户余额
    ,sxf number(22,4) -- 手续费
    ,hydh varchar2(300) -- 行员代号
    ,sjly varchar2(90) -- 数据来源
    ,fphzhye number(22,6) -- 分配后余额
    ,fphsxf number(22,4) -- 分配后手续费
    ,cpfldm varchar2(90) -- 产品分类代码
    ,scddh varchar2(750) -- 商城订单号
    ,fphzhyeylj number(25,4) -- 分配后账户余额月累计
    ,fphzhyejlj number(25,4) -- 分配后账户余额季累计
    ,fphzhyenlj number(25,4) -- 分配后账户余额年累计
    ,zhyeylj number(25,4) -- 账户余额月累计
    ,zhyejlj number(25,4) -- 账户余额季累计
    ,zhyenlj number(25,4) -- 账户余额年累计
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
grant select on ${iol_schema}.pams_nbzz_gjsmx_recal to ${iml_schema};
grant select on ${iol_schema}.pams_nbzz_gjsmx_recal to ${icl_schema};
grant select on ${iol_schema}.pams_nbzz_gjsmx_recal to ${idl_schema};
grant select on ${iol_schema}.pams_nbzz_gjsmx_recal to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_nbzz_gjsmx_recal is '贵金属明细账-重算';
comment on column ${iol_schema}.pams_nbzz_gjsmx_recal.recal_dt is '重算窗口日期';
comment on column ${iol_schema}.pams_nbzz_gjsmx_recal.tjrq is '统计日期';
comment on column ${iol_schema}.pams_nbzz_gjsmx_recal.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_nbzz_gjsmx_recal.khh is '客户号';
comment on column ${iol_schema}.pams_nbzz_gjsmx_recal.jgdh is '机构代号';
comment on column ${iol_schema}.pams_nbzz_gjsmx_recal.khdxdh is '考核对象代号';
comment on column ${iol_schema}.pams_nbzz_gjsmx_recal.jgkhdxdh is '机构考核对象代号';
comment on column ${iol_schema}.pams_nbzz_gjsmx_recal.bz is '币种';
comment on column ${iol_schema}.pams_nbzz_gjsmx_recal.fpjs is '分配角色';
comment on column ${iol_schema}.pams_nbzz_gjsmx_recal.zlbl is '增量比例';
comment on column ${iol_schema}.pams_nbzz_gjsmx_recal.ddh is '行内订单号';
comment on column ${iol_schema}.pams_nbzz_gjsmx_recal.yhlsh is '银行流水号';
comment on column ${iol_schema}.pams_nbzz_gjsmx_recal.jyrq is '交易日期';
comment on column ${iol_schema}.pams_nbzz_gjsmx_recal.ddrq is '订单日期';
comment on column ${iol_schema}.pams_nbzz_gjsmx_recal.khmc is '客户名称';
comment on column ${iol_schema}.pams_nbzz_gjsmx_recal.cph is '产品号';
comment on column ${iol_schema}.pams_nbzz_gjsmx_recal.cpmc is '产品名称';
comment on column ${iol_schema}.pams_nbzz_gjsmx_recal.cpcs is '产品成色';
comment on column ${iol_schema}.pams_nbzz_gjsmx_recal.hjl is '含金量';
comment on column ${iol_schema}.pams_nbzz_gjsmx_recal.hyl is '含银量';
comment on column ${iol_schema}.pams_nbzz_gjsmx_recal.gmsl is '购买数量';
comment on column ${iol_schema}.pams_nbzz_gjsmx_recal.gysmc is '供应商名称';
comment on column ${iol_schema}.pams_nbzz_gjsmx_recal.xsqd is '销售渠道';
comment on column ${iol_schema}.pams_nbzz_gjsmx_recal.jydj is '交易单价';
comment on column ${iol_schema}.pams_nbzz_gjsmx_recal.zhye is '账户余额';
comment on column ${iol_schema}.pams_nbzz_gjsmx_recal.sxf is '手续费';
comment on column ${iol_schema}.pams_nbzz_gjsmx_recal.hydh is '行员代号';
comment on column ${iol_schema}.pams_nbzz_gjsmx_recal.sjly is '数据来源';
comment on column ${iol_schema}.pams_nbzz_gjsmx_recal.fphzhye is '分配后余额';
comment on column ${iol_schema}.pams_nbzz_gjsmx_recal.fphsxf is '分配后手续费';
comment on column ${iol_schema}.pams_nbzz_gjsmx_recal.cpfldm is '产品分类代码';
comment on column ${iol_schema}.pams_nbzz_gjsmx_recal.scddh is '商城订单号';
comment on column ${iol_schema}.pams_nbzz_gjsmx_recal.fphzhyeylj is '分配后账户余额月累计';
comment on column ${iol_schema}.pams_nbzz_gjsmx_recal.fphzhyejlj is '分配后账户余额季累计';
comment on column ${iol_schema}.pams_nbzz_gjsmx_recal.fphzhyenlj is '分配后账户余额年累计';
comment on column ${iol_schema}.pams_nbzz_gjsmx_recal.zhyeylj is '账户余额月累计';
comment on column ${iol_schema}.pams_nbzz_gjsmx_recal.zhyejlj is '账户余额季累计';
comment on column ${iol_schema}.pams_nbzz_gjsmx_recal.zhyenlj is '账户余额年累计';
comment on column ${iol_schema}.pams_nbzz_gjsmx_recal.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_nbzz_gjsmx_recal.etl_timestamp is 'ETL处理时间戳';
