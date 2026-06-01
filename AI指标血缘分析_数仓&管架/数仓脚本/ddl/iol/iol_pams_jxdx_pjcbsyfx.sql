/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxdx_pjcbsyfx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxdx_pjcbsyfx
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxdx_pjcbsyfx purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxdx_pjcbsyfx(
    jxdxdh number(22,0) -- 绩效对象代号
    ,tjrq varchar2(12) -- 数据日期
    ,zqdm varchar2(24) -- 债券代码
    ,tzid number(5,0) -- 投组id
    ,zqmc varchar2(192) -- 债券名称
    ,qxrq varchar2(12) -- 起息日
    ,dqrq varchar2(12) -- 到期日
    ,me number(17,2) -- 面额
    ,sybj number(17,2) -- 剩余本金
    ,pjcb number(17,2) -- 平均成本
    ,zytjj number(17,2) -- 折溢摊净价
    ,yjlx number(17,2) -- 应计利息
    ,zcfzfl varchar2(2) -- 资产负债分类
    ,zqdmmc varchar2(384) -- 债券代码名称
    ,bz varchar2(12) -- 币别
    ,xzrq number(22) -- 修正久期
    ,dv01 varchar2(150) -- DV01
    ,jytzmc varchar2(384) -- 交易投组名称
    ,tzsfl varchar2(75) -- 投组三分类
    ,zhid number(22,0) -- 账户ID
    ,zhdm varchar2(30) -- 账户代码
    ,zhmc varchar2(75) -- 账户名称
    ,jgdh varchar2(15) -- 部门机构
    ,bzcp varchar2(15) -- 标准产品
    ,dqsyl number(27,12) -- 到期收益率
    ,dcq varchar2(192) -- 待偿期
    ,zqlx varchar2(24) -- 债券类型
    ,lxsr number(23,8) -- 利息收入
    ,zyt number(23,8) -- 折溢摊
    ,mmjc number(23,8) -- 买卖价差
    ,fdyk number(23,8) -- 浮动盈亏
    ,hydh varchar2(18) -- 行员代号
    ,khdxdh number(22,0) -- 考核对象代号
    ,gxhslx varchar2(2) -- 关系函数类型
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
grant select on ${iol_schema}.pams_jxdx_pjcbsyfx to ${iml_schema};
grant select on ${iol_schema}.pams_jxdx_pjcbsyfx to ${icl_schema};
grant select on ${iol_schema}.pams_jxdx_pjcbsyfx to ${idl_schema};
grant select on ${iol_schema}.pams_jxdx_pjcbsyfx to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxdx_pjcbsyfx is '绩效对象_平均成本损益分析';
comment on column ${iol_schema}.pams_jxdx_pjcbsyfx.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_jxdx_pjcbsyfx.tjrq is '数据日期';
comment on column ${iol_schema}.pams_jxdx_pjcbsyfx.zqdm is '债券代码';
comment on column ${iol_schema}.pams_jxdx_pjcbsyfx.tzid is '投组id';
comment on column ${iol_schema}.pams_jxdx_pjcbsyfx.zqmc is '债券名称';
comment on column ${iol_schema}.pams_jxdx_pjcbsyfx.qxrq is '起息日';
comment on column ${iol_schema}.pams_jxdx_pjcbsyfx.dqrq is '到期日';
comment on column ${iol_schema}.pams_jxdx_pjcbsyfx.me is '面额';
comment on column ${iol_schema}.pams_jxdx_pjcbsyfx.sybj is '剩余本金';
comment on column ${iol_schema}.pams_jxdx_pjcbsyfx.pjcb is '平均成本';
comment on column ${iol_schema}.pams_jxdx_pjcbsyfx.zytjj is '折溢摊净价';
comment on column ${iol_schema}.pams_jxdx_pjcbsyfx.yjlx is '应计利息';
comment on column ${iol_schema}.pams_jxdx_pjcbsyfx.zcfzfl is '资产负债分类';
comment on column ${iol_schema}.pams_jxdx_pjcbsyfx.zqdmmc is '债券代码名称';
comment on column ${iol_schema}.pams_jxdx_pjcbsyfx.bz is '币别';
comment on column ${iol_schema}.pams_jxdx_pjcbsyfx.xzrq is '修正久期';
comment on column ${iol_schema}.pams_jxdx_pjcbsyfx.dv01 is 'DV01';
comment on column ${iol_schema}.pams_jxdx_pjcbsyfx.jytzmc is '交易投组名称';
comment on column ${iol_schema}.pams_jxdx_pjcbsyfx.tzsfl is '投组三分类';
comment on column ${iol_schema}.pams_jxdx_pjcbsyfx.zhid is '账户ID';
comment on column ${iol_schema}.pams_jxdx_pjcbsyfx.zhdm is '账户代码';
comment on column ${iol_schema}.pams_jxdx_pjcbsyfx.zhmc is '账户名称';
comment on column ${iol_schema}.pams_jxdx_pjcbsyfx.jgdh is '部门机构';
comment on column ${iol_schema}.pams_jxdx_pjcbsyfx.bzcp is '标准产品';
comment on column ${iol_schema}.pams_jxdx_pjcbsyfx.dqsyl is '到期收益率';
comment on column ${iol_schema}.pams_jxdx_pjcbsyfx.dcq is '待偿期';
comment on column ${iol_schema}.pams_jxdx_pjcbsyfx.zqlx is '债券类型';
comment on column ${iol_schema}.pams_jxdx_pjcbsyfx.lxsr is '利息收入';
comment on column ${iol_schema}.pams_jxdx_pjcbsyfx.zyt is '折溢摊';
comment on column ${iol_schema}.pams_jxdx_pjcbsyfx.mmjc is '买卖价差';
comment on column ${iol_schema}.pams_jxdx_pjcbsyfx.fdyk is '浮动盈亏';
comment on column ${iol_schema}.pams_jxdx_pjcbsyfx.hydh is '行员代号';
comment on column ${iol_schema}.pams_jxdx_pjcbsyfx.khdxdh is '考核对象代号';
comment on column ${iol_schema}.pams_jxdx_pjcbsyfx.gxhslx is '关系函数类型';
comment on column ${iol_schema}.pams_jxdx_pjcbsyfx.start_dt is '开始时间';
comment on column ${iol_schema}.pams_jxdx_pjcbsyfx.end_dt is '结束时间';
comment on column ${iol_schema}.pams_jxdx_pjcbsyfx.id_mark is '增删标志';
comment on column ${iol_schema}.pams_jxdx_pjcbsyfx.etl_timestamp is 'ETL处理时间戳';
