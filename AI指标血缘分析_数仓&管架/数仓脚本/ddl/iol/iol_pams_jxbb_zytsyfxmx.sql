/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxbb_zytsyfxmx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxbb_zytsyfxmx
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxbb_zytsyfxmx purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxbb_zytsyfxmx(
    tjrq number(22,0) -- 统计日期
    ,jxdxdh number(22,0) -- 绩效对象代号
    ,khdxdh number(22,0) -- 考核对象代号
    ,jgkhdxdh number(22,0) -- 机构考核对象代号
    ,fpjs varchar2(3) -- 分配角色
    ,zlbl number(19,5) -- 增量比例
    ,bz varchar2(5) -- 币种
    ,hydh varchar2(18) -- 行员代号
    ,hymc varchar2(150) -- 行员名称
    ,gsjgdh varchar2(15) -- 归属机构代号
    ,gsjgmc varchar2(150) -- 归属机构名称
    ,zqdm varchar2(24) -- 债券代码
    ,zqmc varchar2(192) -- 债券名称
    ,qxrq varchar2(45) -- 起息日期
    ,dqrq varchar2(45) -- 到期日期
    ,hyme number(25,4) -- 行员面额
    ,hymeylj number(25,4) -- 行员面额月累计
    ,hymenlj number(25,4) -- 行员面额年累计
    ,hysybj number(25,4) -- 行员剩余本金
    ,hysybjylj number(25,4) -- 行员剩余本金月累计
    ,hysybjnlj number(25,4) -- 行员剩余本金年累计
    ,hypjcb number(25,4) -- 行员平均成本
    ,hypjcbylj number(25,4) -- 行员平均成本月累计
    ,hypjcbnlj number(25,4) -- 行员平均成本年累计
    ,hyzytjj number(25,4) -- 行员折溢摊净价
    ,hyzytjjylj number(25,4) -- 行员折溢摊净价月累计
    ,hyzytjjnlj number(25,4) -- 行员折溢摊净价年累计
    ,hyyjlx number(25,4) -- 行员应计利息
    ,hyyjlxylj number(25,4) -- 行员应计利息月累计
    ,hyyjlxnlj number(25,4) -- 行员应计利息年累计
    ,zcfzfl varchar2(2) -- 资产负债分类
    ,zqdmmc varchar2(384) -- 债券代码名称
    ,xzrq number(22) -- 修正久期
    ,dv01 varchar2(150) -- DV01
    ,tzid number(5,0) -- 投组id
    ,jytzmc varchar2(384) -- 交易投组名称
    ,tzsfl varchar2(75) -- 投组三分类
    ,zhid number(22,0) -- 账户ID
    ,zhdm varchar2(30) -- 账户代码
    ,zhmc varchar2(75) -- 账户名称
    ,khjg varchar2(15) -- 部门机构
    ,bzcp varchar2(15) -- 标准产品
    ,dqsyl number(27,12) -- 到期收益率
    ,dcq varchar2(192) -- 待偿期
    ,zqlx varchar2(24) -- 债券类型
    ,hylxsr number(25,4) -- 行员利息收入
    ,hylxsrylj number(25,4) -- 行员利息收入月累计
    ,hylxsrnlj number(25,4) -- 行员利息收入年累计
    ,hyzyt number(25,4) -- 行员折溢摊
    ,hyzytylj number(25,4) -- 行员折溢摊月累计
    ,hyzytnlj number(25,4) -- 行员折溢摊年累计
    ,hymmjc number(25,4) -- 行员买卖价差
    ,hymmjcylj number(25,4) -- 行员买卖价差月累计
    ,hymmjcnlj number(25,4) -- 行员买卖价差年累计
    ,hyfdyk number(25,4) -- 行员浮动盈亏
    ,hyfdykylj number(25,4) -- 行员浮动盈亏月累计
    ,hyfdyknlj number(25,4) -- 行员浮动盈亏年累计
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
grant select on ${iol_schema}.pams_jxbb_zytsyfxmx to ${iml_schema};
grant select on ${iol_schema}.pams_jxbb_zytsyfxmx to ${icl_schema};
grant select on ${iol_schema}.pams_jxbb_zytsyfxmx to ${idl_schema};
grant select on ${iol_schema}.pams_jxbb_zytsyfxmx to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxbb_zytsyfxmx is '绩效报表_折溢摊损益分析结果表';
comment on column ${iol_schema}.pams_jxbb_zytsyfxmx.tjrq is '统计日期';
comment on column ${iol_schema}.pams_jxbb_zytsyfxmx.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_jxbb_zytsyfxmx.khdxdh is '考核对象代号';
comment on column ${iol_schema}.pams_jxbb_zytsyfxmx.jgkhdxdh is '机构考核对象代号';
comment on column ${iol_schema}.pams_jxbb_zytsyfxmx.fpjs is '分配角色';
comment on column ${iol_schema}.pams_jxbb_zytsyfxmx.zlbl is '增量比例';
comment on column ${iol_schema}.pams_jxbb_zytsyfxmx.bz is '币种';
comment on column ${iol_schema}.pams_jxbb_zytsyfxmx.hydh is '行员代号';
comment on column ${iol_schema}.pams_jxbb_zytsyfxmx.hymc is '行员名称';
comment on column ${iol_schema}.pams_jxbb_zytsyfxmx.gsjgdh is '归属机构代号';
comment on column ${iol_schema}.pams_jxbb_zytsyfxmx.gsjgmc is '归属机构名称';
comment on column ${iol_schema}.pams_jxbb_zytsyfxmx.zqdm is '债券代码';
comment on column ${iol_schema}.pams_jxbb_zytsyfxmx.zqmc is '债券名称';
comment on column ${iol_schema}.pams_jxbb_zytsyfxmx.qxrq is '起息日期';
comment on column ${iol_schema}.pams_jxbb_zytsyfxmx.dqrq is '到期日期';
comment on column ${iol_schema}.pams_jxbb_zytsyfxmx.hyme is '行员面额';
comment on column ${iol_schema}.pams_jxbb_zytsyfxmx.hymeylj is '行员面额月累计';
comment on column ${iol_schema}.pams_jxbb_zytsyfxmx.hymenlj is '行员面额年累计';
comment on column ${iol_schema}.pams_jxbb_zytsyfxmx.hysybj is '行员剩余本金';
comment on column ${iol_schema}.pams_jxbb_zytsyfxmx.hysybjylj is '行员剩余本金月累计';
comment on column ${iol_schema}.pams_jxbb_zytsyfxmx.hysybjnlj is '行员剩余本金年累计';
comment on column ${iol_schema}.pams_jxbb_zytsyfxmx.hypjcb is '行员平均成本';
comment on column ${iol_schema}.pams_jxbb_zytsyfxmx.hypjcbylj is '行员平均成本月累计';
comment on column ${iol_schema}.pams_jxbb_zytsyfxmx.hypjcbnlj is '行员平均成本年累计';
comment on column ${iol_schema}.pams_jxbb_zytsyfxmx.hyzytjj is '行员折溢摊净价';
comment on column ${iol_schema}.pams_jxbb_zytsyfxmx.hyzytjjylj is '行员折溢摊净价月累计';
comment on column ${iol_schema}.pams_jxbb_zytsyfxmx.hyzytjjnlj is '行员折溢摊净价年累计';
comment on column ${iol_schema}.pams_jxbb_zytsyfxmx.hyyjlx is '行员应计利息';
comment on column ${iol_schema}.pams_jxbb_zytsyfxmx.hyyjlxylj is '行员应计利息月累计';
comment on column ${iol_schema}.pams_jxbb_zytsyfxmx.hyyjlxnlj is '行员应计利息年累计';
comment on column ${iol_schema}.pams_jxbb_zytsyfxmx.zcfzfl is '资产负债分类';
comment on column ${iol_schema}.pams_jxbb_zytsyfxmx.zqdmmc is '债券代码名称';
comment on column ${iol_schema}.pams_jxbb_zytsyfxmx.xzrq is '修正久期';
comment on column ${iol_schema}.pams_jxbb_zytsyfxmx.dv01 is 'DV01';
comment on column ${iol_schema}.pams_jxbb_zytsyfxmx.tzid is '投组id';
comment on column ${iol_schema}.pams_jxbb_zytsyfxmx.jytzmc is '交易投组名称';
comment on column ${iol_schema}.pams_jxbb_zytsyfxmx.tzsfl is '投组三分类';
comment on column ${iol_schema}.pams_jxbb_zytsyfxmx.zhid is '账户ID';
comment on column ${iol_schema}.pams_jxbb_zytsyfxmx.zhdm is '账户代码';
comment on column ${iol_schema}.pams_jxbb_zytsyfxmx.zhmc is '账户名称';
comment on column ${iol_schema}.pams_jxbb_zytsyfxmx.khjg is '部门机构';
comment on column ${iol_schema}.pams_jxbb_zytsyfxmx.bzcp is '标准产品';
comment on column ${iol_schema}.pams_jxbb_zytsyfxmx.dqsyl is '到期收益率';
comment on column ${iol_schema}.pams_jxbb_zytsyfxmx.dcq is '待偿期';
comment on column ${iol_schema}.pams_jxbb_zytsyfxmx.zqlx is '债券类型';
comment on column ${iol_schema}.pams_jxbb_zytsyfxmx.hylxsr is '行员利息收入';
comment on column ${iol_schema}.pams_jxbb_zytsyfxmx.hylxsrylj is '行员利息收入月累计';
comment on column ${iol_schema}.pams_jxbb_zytsyfxmx.hylxsrnlj is '行员利息收入年累计';
comment on column ${iol_schema}.pams_jxbb_zytsyfxmx.hyzyt is '行员折溢摊';
comment on column ${iol_schema}.pams_jxbb_zytsyfxmx.hyzytylj is '行员折溢摊月累计';
comment on column ${iol_schema}.pams_jxbb_zytsyfxmx.hyzytnlj is '行员折溢摊年累计';
comment on column ${iol_schema}.pams_jxbb_zytsyfxmx.hymmjc is '行员买卖价差';
comment on column ${iol_schema}.pams_jxbb_zytsyfxmx.hymmjcylj is '行员买卖价差月累计';
comment on column ${iol_schema}.pams_jxbb_zytsyfxmx.hymmjcnlj is '行员买卖价差年累计';
comment on column ${iol_schema}.pams_jxbb_zytsyfxmx.hyfdyk is '行员浮动盈亏';
comment on column ${iol_schema}.pams_jxbb_zytsyfxmx.hyfdykylj is '行员浮动盈亏月累计';
comment on column ${iol_schema}.pams_jxbb_zytsyfxmx.hyfdyknlj is '行员浮动盈亏年累计';
comment on column ${iol_schema}.pams_jxbb_zytsyfxmx.start_dt is '开始时间';
comment on column ${iol_schema}.pams_jxbb_zytsyfxmx.end_dt is '结束时间';
comment on column ${iol_schema}.pams_jxbb_zytsyfxmx.id_mark is '增删标志';
comment on column ${iol_schema}.pams_jxbb_zytsyfxmx.etl_timestamp is 'ETL处理时间戳';
