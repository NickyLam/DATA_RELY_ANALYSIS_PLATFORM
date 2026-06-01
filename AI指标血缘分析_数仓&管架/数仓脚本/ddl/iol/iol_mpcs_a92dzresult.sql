/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a92dzresult
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a92dzresult
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a92dzresult purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a92dzresult(
    ztsdatetime varchar2(21) -- 中台系统日期时间
    ,settldate varchar2(12) -- 清算日期(交易日)
    ,ymstatus varchar2(2) -- 盈米订单流水对账状态          0:未对账，1:成功，2:失败，8-勾兑完成（等待批次程序生成批次），9-正在对账（等待upp结果）
    ,acctdatestatus varchar2(2) -- 资金到期日对账状态      0:未对账，1:成功，2:失败，8-勾兑完成（等待分红数据），9-正在对账（等待upp结果）
    ,fcdivstatus varchar2(2) -- 基金公司分红数据对账状态      0:未对账，1:成功，2:失败，8-信息汇总完成（等待资金到期日数据），9-正在对账（等待upp结果）
    ,fcdivtotcount varchar2(24) -- 分红文件总笔数
    ,fcdivtotamt varchar2(30) -- 分红文件总金额
    ,fcintotcount varchar2(24) -- 盈米对账交易流水转入总笔数(申购、认购、定投申购)
    ,fcintotamt varchar2(30) -- 盈米对账交易流水转入总金额(申购、认购、定投申购)
    ,fcouttotcount varchar2(24) -- 基金公司对账交易流水转出总笔数(申购确认失败、认购全比例确认失败、赎回成功、认购部分失败)
    ,fcouttotamt varchar2(30) -- 基金公司对账交易流水转出总金额(申购确认失败、认购全比例确认失败、赎回成功、认购部分失败)
    ,cbsincount varchar2(24) -- 主机对账交易流水转入成功笔数(申购、认购、定投申购)
    ,cbsinamt varchar2(30) -- 主机对账交易流水转入成功金额(申购、认购、定投申购)
    ,cbsoutcount varchar2(24) -- 主机对账交易流水转出成功笔数(申购确认失败、认购全比例确认失败、赎回成功、认购部分失败)
    ,cbsoutamt varchar2(30) -- 主机对账交易流水转出成功金额(申购确认失败、认购全比例确认失败、赎回成功、认购部分失败)
    ,cbsdivcount varchar2(24) -- 主机分红对账交易成功笔数
    ,cbsdivamt varchar2(30) -- 主机分红对账交易成功金额
    ,dzerrmsg varchar2(384) -- 对账错误描述信息
    ,isworkday varchar2(2) -- 是否工作日  0-否 1-是
    ,reserve1 varchar2(384) -- 保留域1
    ,reserve2 varchar2(384) -- 保留域2
    ,reserve3 varchar2(384) -- 保留域3
    ,reserve4 varchar2(384) -- 保留域4
    ,reserve5 varchar2(384) -- 保留域5
    ,ordertotamt varchar2(30) -- 盈米订单文件购买类委托成功总金额
    ,ordertotcount varchar2(24) -- 盈米订单文件购买类委托成功总笔数
    ,confirmtotamt varchar2(30) -- 盈米确认文件入账客户账总金额
    ,confirmtotcount varchar2(24) -- 盈米确认文件入账客户账总笔数
    ,nettingoutflg varchar2(2) -- 赎回清算户转出标记 0--正常或无校验 1--长款 2--短款 3--接口查询失败
    ,nettinginflg varchar2(2) -- 申、认购清算户转入标记 0--正常或无校验 1--长款 3--接口查询失败
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
grant select on ${iol_schema}.mpcs_a92dzresult to ${iml_schema};
grant select on ${iol_schema}.mpcs_a92dzresult to ${icl_schema};
grant select on ${iol_schema}.mpcs_a92dzresult to ${idl_schema};
grant select on ${iol_schema}.mpcs_a92dzresult to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a92dzresult is '盈米对账结果';
comment on column ${iol_schema}.mpcs_a92dzresult.ztsdatetime is '中台系统日期时间';
comment on column ${iol_schema}.mpcs_a92dzresult.settldate is '清算日期(交易日)';
comment on column ${iol_schema}.mpcs_a92dzresult.ymstatus is '盈米订单流水对账状态          0:未对账，1:成功，2:失败，8-勾兑完成（等待批次程序生成批次），9-正在对账（等待upp结果）';
comment on column ${iol_schema}.mpcs_a92dzresult.acctdatestatus is '资金到期日对账状态      0:未对账，1:成功，2:失败，8-勾兑完成（等待分红数据），9-正在对账（等待upp结果）';
comment on column ${iol_schema}.mpcs_a92dzresult.fcdivstatus is '基金公司分红数据对账状态      0:未对账，1:成功，2:失败，8-信息汇总完成（等待资金到期日数据），9-正在对账（等待upp结果）';
comment on column ${iol_schema}.mpcs_a92dzresult.fcdivtotcount is '分红文件总笔数';
comment on column ${iol_schema}.mpcs_a92dzresult.fcdivtotamt is '分红文件总金额';
comment on column ${iol_schema}.mpcs_a92dzresult.fcintotcount is '盈米对账交易流水转入总笔数(申购、认购、定投申购)';
comment on column ${iol_schema}.mpcs_a92dzresult.fcintotamt is '盈米对账交易流水转入总金额(申购、认购、定投申购)';
comment on column ${iol_schema}.mpcs_a92dzresult.fcouttotcount is '基金公司对账交易流水转出总笔数(申购确认失败、认购全比例确认失败、赎回成功、认购部分失败)';
comment on column ${iol_schema}.mpcs_a92dzresult.fcouttotamt is '基金公司对账交易流水转出总金额(申购确认失败、认购全比例确认失败、赎回成功、认购部分失败)';
comment on column ${iol_schema}.mpcs_a92dzresult.cbsincount is '主机对账交易流水转入成功笔数(申购、认购、定投申购)';
comment on column ${iol_schema}.mpcs_a92dzresult.cbsinamt is '主机对账交易流水转入成功金额(申购、认购、定投申购)';
comment on column ${iol_schema}.mpcs_a92dzresult.cbsoutcount is '主机对账交易流水转出成功笔数(申购确认失败、认购全比例确认失败、赎回成功、认购部分失败)';
comment on column ${iol_schema}.mpcs_a92dzresult.cbsoutamt is '主机对账交易流水转出成功金额(申购确认失败、认购全比例确认失败、赎回成功、认购部分失败)';
comment on column ${iol_schema}.mpcs_a92dzresult.cbsdivcount is '主机分红对账交易成功笔数';
comment on column ${iol_schema}.mpcs_a92dzresult.cbsdivamt is '主机分红对账交易成功金额';
comment on column ${iol_schema}.mpcs_a92dzresult.dzerrmsg is '对账错误描述信息';
comment on column ${iol_schema}.mpcs_a92dzresult.isworkday is '是否工作日  0-否 1-是';
comment on column ${iol_schema}.mpcs_a92dzresult.reserve1 is '保留域1';
comment on column ${iol_schema}.mpcs_a92dzresult.reserve2 is '保留域2';
comment on column ${iol_schema}.mpcs_a92dzresult.reserve3 is '保留域3';
comment on column ${iol_schema}.mpcs_a92dzresult.reserve4 is '保留域4';
comment on column ${iol_schema}.mpcs_a92dzresult.reserve5 is '保留域5';
comment on column ${iol_schema}.mpcs_a92dzresult.ordertotamt is '盈米订单文件购买类委托成功总金额';
comment on column ${iol_schema}.mpcs_a92dzresult.ordertotcount is '盈米订单文件购买类委托成功总笔数';
comment on column ${iol_schema}.mpcs_a92dzresult.confirmtotamt is '盈米确认文件入账客户账总金额';
comment on column ${iol_schema}.mpcs_a92dzresult.confirmtotcount is '盈米确认文件入账客户账总笔数';
comment on column ${iol_schema}.mpcs_a92dzresult.nettingoutflg is '赎回清算户转出标记 0--正常或无校验 1--长款 2--短款 3--接口查询失败';
comment on column ${iol_schema}.mpcs_a92dzresult.nettinginflg is '申、认购清算户转入标记 0--正常或无校验 1--长款 3--接口查询失败';
comment on column ${iol_schema}.mpcs_a92dzresult.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a92dzresult.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a92dzresult.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a92dzresult.etl_timestamp is 'ETL处理时间戳';
