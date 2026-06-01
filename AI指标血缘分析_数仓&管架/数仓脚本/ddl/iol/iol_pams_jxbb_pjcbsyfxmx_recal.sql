/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxbb_pjcbsyfxmx_recal
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal(
    tjrq number(22) -- 统计日期
    ,jxdxdh number(22) -- 绩效对象代号
    ,khdxdh number(22) -- 考核对象代号
    ,jgkhdxdh number(22) -- 机构考核对象代号
    ,fpjs varchar2(6) -- 分配角色
    ,zlbl number(19,5) -- 认领比例
    ,bz varchar2(9) -- 币种
    ,hydh varchar2(36) -- 行员代号
    ,hymc varchar2(300) -- 行员名称
    ,gsjgdh varchar2(30) -- 归属机构代号
    ,gsjgmc varchar2(300) -- 归属机构名称
    ,zqdm varchar2(48) -- 债券代码
    ,zqmc varchar2(384) -- 债券名称
    ,qxrq varchar2(24) -- 起息日期
    ,dqrq varchar2(24) -- 到期日期
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
    ,zcfzfl varchar2(3) -- 资产负债分类
    ,zqdmmc varchar2(768) -- 债券代码名称
    ,xzrq number(22) -- 修正久期
    ,dv01 varchar2(300) -- DV01
    ,tzid number(5) -- 投组id
    ,jytzmc varchar2(768) -- 交易投组名称
    ,tzsfl varchar2(150) -- 投组三分类
    ,zhid number(22) -- 账户ID
    ,zhdm varchar2(60) -- 账户代码
    ,zhmc varchar2(150) -- 账户名称
    ,khjg varchar2(30) -- 部门机构
    ,bzcp varchar2(36) -- 标准产品
    ,dqsyl number(27,12) -- 到期收益率
    ,dcq varchar2(384) -- 待偿期
    ,zqlx varchar2(48) -- 债券类型
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
    ,recal_dt number(22) -- 重算日期
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
grant select on ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal to ${iml_schema};
grant select on ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal to ${icl_schema};
grant select on ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal to ${idl_schema};
grant select on ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal is '绩效报表_平均成本损益分析结果表_重算';
comment on column ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal.tjrq is '统计日期';
comment on column ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal.khdxdh is '考核对象代号';
comment on column ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal.jgkhdxdh is '机构考核对象代号';
comment on column ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal.fpjs is '分配角色';
comment on column ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal.zlbl is '认领比例';
comment on column ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal.bz is '币种';
comment on column ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal.hydh is '行员代号';
comment on column ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal.hymc is '行员名称';
comment on column ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal.gsjgdh is '归属机构代号';
comment on column ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal.gsjgmc is '归属机构名称';
comment on column ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal.zqdm is '债券代码';
comment on column ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal.zqmc is '债券名称';
comment on column ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal.qxrq is '起息日期';
comment on column ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal.dqrq is '到期日期';
comment on column ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal.hyme is '行员面额';
comment on column ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal.hymeylj is '行员面额月累计';
comment on column ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal.hymenlj is '行员面额年累计';
comment on column ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal.hysybj is '行员剩余本金';
comment on column ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal.hysybjylj is '行员剩余本金月累计';
comment on column ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal.hysybjnlj is '行员剩余本金年累计';
comment on column ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal.hypjcb is '行员平均成本';
comment on column ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal.hypjcbylj is '行员平均成本月累计';
comment on column ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal.hypjcbnlj is '行员平均成本年累计';
comment on column ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal.hyzytjj is '行员折溢摊净价';
comment on column ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal.hyzytjjylj is '行员折溢摊净价月累计';
comment on column ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal.hyzytjjnlj is '行员折溢摊净价年累计';
comment on column ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal.hyyjlx is '行员应计利息';
comment on column ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal.hyyjlxylj is '行员应计利息月累计';
comment on column ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal.hyyjlxnlj is '行员应计利息年累计';
comment on column ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal.zcfzfl is '资产负债分类';
comment on column ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal.zqdmmc is '债券代码名称';
comment on column ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal.xzrq is '修正久期';
comment on column ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal.dv01 is 'DV01';
comment on column ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal.tzid is '投组id';
comment on column ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal.jytzmc is '交易投组名称';
comment on column ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal.tzsfl is '投组三分类';
comment on column ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal.zhid is '账户ID';
comment on column ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal.zhdm is '账户代码';
comment on column ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal.zhmc is '账户名称';
comment on column ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal.khjg is '部门机构';
comment on column ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal.bzcp is '标准产品';
comment on column ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal.dqsyl is '到期收益率';
comment on column ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal.dcq is '待偿期';
comment on column ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal.zqlx is '债券类型';
comment on column ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal.hylxsr is '行员利息收入';
comment on column ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal.hylxsrylj is '行员利息收入月累计';
comment on column ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal.hylxsrnlj is '行员利息收入年累计';
comment on column ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal.hyzyt is '行员折溢摊';
comment on column ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal.hyzytylj is '行员折溢摊月累计';
comment on column ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal.hyzytnlj is '行员折溢摊年累计';
comment on column ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal.hymmjc is '行员买卖价差';
comment on column ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal.hymmjcylj is '行员买卖价差月累计';
comment on column ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal.hymmjcnlj is '行员买卖价差年累计';
comment on column ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal.hyfdyk is '行员浮动盈亏';
comment on column ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal.hyfdykylj is '行员浮动盈亏月累计';
comment on column ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal.hyfdyknlj is '行员浮动盈亏年累计';
comment on column ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal.recal_dt is '重算日期';
comment on column ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal.etl_timestamp is 'ETL处理时间戳';
