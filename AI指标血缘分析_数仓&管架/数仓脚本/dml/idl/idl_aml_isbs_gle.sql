/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_aml_isbs_gle
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 4;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.aml_isbs_gle drop partition p_${last_date};
alter table ${idl_schema}.aml_isbs_gle drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.aml_isbs_gle add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.aml_isbs_gle partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,inr  -- 内部唯一ID
    ,objtyp  -- 对象表名称
    ,objinr  -- 对象表INR
    ,trninr  -- TRN表的INR
    ,act  -- 帐号
    ,dbtcdt  -- 借贷标志
    ,cur  -- 记账币种
    ,amt  -- 记账金额
    ,syscur  -- 规定币种
    ,sysamt  -- 规定币种类型金额
    ,valdat  -- 起息日
    ,bucdat  -- 记录生成日期
    ,txt1  -- 摘要1
    ,txt2  -- 传票摘要
    ,txt3  -- 摘要3
    ,prn  -- 分录顺序
    ,expses  -- 出口用户会话
    ,expflg  -- 出口状态
    ,acttrncod  -- 传票打印类型
    ,branchinr  -- 业务记账机构
    ,dbtdft  -- 借据号（融资时）
    ,peeact  -- 对应帐号
    ,rat  -- 汇率
    ,trdtyp  -- 交易类型
    ,cliextkey  -- 客户号
    ,whmtyp  -- 结售汇类型
    ,gleord  -- 分录顺序号
    ,newactcod  -- 核心系统交易代码
    ,trmtyp  -- 科目代号
    ,trnman  -- 结售汇交易主体
    ,midrat  -- 中间价
    ,xrttim  -- 中间价的牌价时间
    ,income  -- 结售汇损益
    ,sumtyp  -- 摘要类型
    ,acttyp  -- 帐目类型
    ,cshflg  -- 现金标志
    ,tracode  -- 交易代码
    ,ctycode  -- 国家标志
    ,apvnum  -- 批准号
    ,othfin  -- 对方银行名称
    ,selrat  -- 卖出汇率
    ,buyrat  -- 买入汇率
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.inr,chr(13),''),chr(10),'')  -- 内部唯一ID
    ,replace(replace(t1.objtyp,chr(13),''),chr(10),'')  -- 对象表名称
    ,replace(replace(t1.objinr,chr(13),''),chr(10),'')  -- 对象表INR
    ,replace(replace(t1.trninr,chr(13),''),chr(10),'')  -- TRN表的INR
    ,replace(replace(t1.act,chr(13),''),chr(10),'')  -- 帐号
    ,replace(replace(t1.dbtcdt,chr(13),''),chr(10),'')  -- 借贷标志
    ,replace(replace(t1.cur,chr(13),''),chr(10),'')  -- 记账币种
    ,t1.amt  -- 记账金额
    ,replace(replace(t1.syscur,chr(13),''),chr(10),'')  -- 规定币种
    ,t1.sysamt  -- 规定币种类型金额
    ,t1.valdat  -- 起息日
    ,t1.bucdat  -- 记录生成日期
    ,replace(replace(t1.txt1,chr(13),''),chr(10),'')  -- 摘要1
    ,replace(replace(t1.txt2,chr(13),''),chr(10),'')  -- 传票摘要
    ,replace(replace(t1.txt3,chr(13),''),chr(10),'')  -- 摘要3
    ,replace(replace(t1.prn,chr(13),''),chr(10),'')  -- 分录顺序
    ,replace(replace(t1.expses,chr(13),''),chr(10),'')  -- 出口用户会话
    ,replace(replace(t1.expflg,chr(13),''),chr(10),'')  -- 出口状态
    ,replace(replace(t1.acttrncod,chr(13),''),chr(10),'')  -- 传票打印类型
    ,replace(replace(t1.branchinr,chr(13),''),chr(10),'')  -- 业务记账机构
    ,replace(replace(t1.dbtdft,chr(13),''),chr(10),'')  -- 借据号（融资时） 
    ,replace(replace(t1.peeact,chr(13),''),chr(10),'')  -- 对应帐号
    ,t1.rat  -- 汇率
    ,replace(replace(t1.trdtyp,chr(13),''),chr(10),'')  -- 交易类型
    ,replace(replace(t1.cliextkey,chr(13),''),chr(10),'')  -- 客户号
    ,replace(replace(t1.whmtyp,chr(13),''),chr(10),'')  -- 结售汇类型
    ,replace(replace(t1.gleord,chr(13),''),chr(10),'')  -- 分录顺序号
    ,replace(replace(t1.newactcod,chr(13),''),chr(10),'')  -- 核心系统交易代码
    ,replace(replace(t1.trmtyp,chr(13),''),chr(10),'')  -- 科目代号
    ,replace(replace(t1.trnman,chr(13),''),chr(10),'')  -- 结售汇交易主体
    ,t1.midrat  -- 中间价
    ,replace(replace(t1.xrttim,chr(13),''),chr(10),'')  -- 中间价的牌价时间
    ,t1.income  -- 结售汇损益
    ,replace(replace(t1.sumtyp,chr(13),''),chr(10),'')  -- 摘要类型
    ,replace(replace(t1.acttyp,chr(13),''),chr(10),'')  -- 帐目类型
    ,replace(replace(t1.cshflg,chr(13),''),chr(10),'')  -- 现金标志
    ,replace(replace(t1.tracode,chr(13),''),chr(10),'')  -- 交易代码
    ,replace(replace(t1.ctycode,chr(13),''),chr(10),'')  -- 国家标志
    ,replace(replace(t1.apvnum,chr(13),''),chr(10),'')  -- 批准号
    ,replace(replace(t1.othfin,chr(13),''),chr(10),'')  -- 对方银行名称
    ,t1.selrat  -- 卖出汇率
    ,t1.buyrat  -- 买入汇率
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.isbs_gle t1    --general ledger会计分录信息
where t1.start_dt <=to_date('${batch_date}','yyyymmdd') and t1.end_dt >to_date('${batch_date}','yyyymmdd') and t1.id_mark <> 'D' ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'aml_isbs_gle',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);