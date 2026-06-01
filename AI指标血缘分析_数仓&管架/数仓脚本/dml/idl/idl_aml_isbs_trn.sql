/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_aml_isbs_trn
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
alter table ${idl_schema}.aml_isbs_trn drop partition p_${last_date};
alter table ${idl_schema}.aml_isbs_trn drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.aml_isbs_trn add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.aml_isbs_trn partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,inr  -- 内部唯一ID
    ,inidattim  -- 开立日期
    ,inifrm  -- 交易名
    ,iniusr  -- 用户ID
    ,ininam  -- 交易名
    ,ownref  -- 参考号
    ,objtyp  -- 业务表名称
    ,objinr  -- 业务表INR
    ,objnam  -- 交易对象描述
    ,ssninr  -- 连接 ID
    ,smhnxt  -- 报文、面函个数
    ,usg  -- 操作员组
    ,usr  -- 操作员
    ,cpldattim  -- 完成日期
    ,infdsp  -- 显示信息
    ,inftxt  -- 信息文本
    ,relflg  -- 授权状态
    ,comflg  -- 提交标志
    ,comdat  -- 提交日期
    ,cortrninr  -- 被删除或需要修改的TRN的INR
    ,xreflg  -- 重算标志
    ,xrecurblk  -- 可用货币
    ,relcur  -- 授权币种
    ,relamt  -- 授权金额
    ,reloricur  -- 币种
    ,reloriamt  -- 金额
    ,relreq  -- 授权请求状态
    ,relres  -- 签名状态
    ,cnfflg  -- 国外确认标志
    ,evttxt  -- Event事件描述
    ,rprusr  -- 退回到指定人员
    ,ordinr  -- ORD表inr
    ,exedat  -- 执行日期
    ,etyextkey  -- 实体
    ,bchkeyinr  -- 经办机构
    ,accbchinr  -- 记账机构
    ,relreq0  -- 单证中心授权请求
    ,relreq1  -- 分行授权请求
    ,relreq2  -- 支行授权请求
    ,relres0  -- 单证中心签名
    ,relres1  -- 分行签名
    ,relres2  -- 支行签名
    ,relusr1  -- 授权用户
    ,relusr2  -- 授权用户
    ,relusr3  -- 授权用户
    ,imginr  -- 图像inr
    ,branchinr  -- 业务所属支行INR
    ,orgflg  -- 机构标识
    ,addtxt  -- 附加信息
    ,gylsh  -- 核心柜员流水号
    ,gylsh1  -- 核心表外柜员流水号
    ,yewgzh  -- 业务跟踪号
    ,cmtflg  -- CMT100报文标识
    ,ctrbnknum  -- 对手行行号
    ,ctrbnknam  -- 对手行行名
    ,qjls  -- 全局流水号
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.inr,chr(13),''),chr(10),'')  -- 内部唯一ID
    ,t1.inidattim  -- 开立日期
    ,replace(replace(t1.inifrm,chr(13),''),chr(10),'')  -- 交易名
    ,replace(replace(t1.iniusr,chr(13),''),chr(10),'')  -- 用户ID
    ,replace(replace(t1.ininam,chr(13),''),chr(10),'')  -- 交易名
    ,replace(replace(t1.ownref,chr(13),''),chr(10),'')  -- 参考号
    ,replace(replace(t1.objtyp,chr(13),''),chr(10),'')  -- 业务表名称
    ,replace(replace(t1.objinr,chr(13),''),chr(10),'')  -- 业务表INR
    ,replace(replace(t1.objnam,chr(13),''),chr(10),'')  -- 交易对象描述
    ,replace(replace(t1.ssninr,chr(13),''),chr(10),'')  -- 连接 ID
    ,t1.smhnxt  -- 报文、面函个数
    ,replace(replace(t1.usg,chr(13),''),chr(10),'')  -- 操作员组
    ,replace(replace(t1.usr,chr(13),''),chr(10),'')  -- 操作员
    ,t1.cpldattim  -- 完成日期
    ,replace(replace(t1.infdsp,chr(13),''),chr(10),'')  -- 显示信息
    ,replace(replace(t1.inftxt,chr(13),''),chr(10),'')  -- 信息文本
    ,replace(replace(t1.relflg,chr(13),''),chr(10),'')  -- 授权状态
    ,replace(replace(t1.comflg,chr(13),''),chr(10),'')  -- 提交标志
    ,t1.comdat  -- 提交日期
    ,replace(replace(t1.cortrninr,chr(13),''),chr(10),'')  -- 被删除或需要修改的TRN的INR
    ,replace(replace(t1.xreflg,chr(13),''),chr(10),'')  -- 重算标志
    ,replace(replace(t1.xrecurblk,chr(13),''),chr(10),'')  -- 可用货币
    ,replace(replace(t1.relcur,chr(13),''),chr(10),'')  -- 授权币种
    ,t1.relamt  -- 授权金额
    ,replace(replace(t1.reloricur,chr(13),''),chr(10),'')  -- 币种
    ,t1.reloriamt  -- 金额
    ,replace(replace(t1.relreq,chr(13),''),chr(10),'')  -- 授权请求状态
    ,replace(replace(t1.relres,chr(13),''),chr(10),'')  -- 签名状态
    ,replace(replace(t1.cnfflg,chr(13),''),chr(10),'')  -- 国外确认标志
    ,replace(replace(t1.evttxt,chr(13),''),chr(10),'')  -- Event事件描述
    ,replace(replace(t1.rprusr,chr(13),''),chr(10),'')  -- 退回到指定人员
    ,replace(replace(t1.ordinr,chr(13),''),chr(10),'')  -- ORD表inr
    ,t1.exedat  -- 执行日期
    ,replace(replace(t1.etyextkey,chr(13),''),chr(10),'')  -- 实体
    ,replace(replace(t1.bchkeyinr,chr(13),''),chr(10),'')  -- 经办机构
    ,replace(replace(t1.accbchinr,chr(13),''),chr(10),'')  -- 记账机构
    ,replace(replace(t1.relreq0,chr(13),''),chr(10),'')  -- 单证中心授权请求
    ,replace(replace(t1.relreq1,chr(13),''),chr(10),'')  -- 分行授权请求
    ,replace(replace(t1.relreq2,chr(13),''),chr(10),'')  -- 支行授权请求
    ,replace(replace(t1.relres0,chr(13),''),chr(10),'')  -- 单证中心签名
    ,replace(replace(t1.relres1,chr(13),''),chr(10),'')  -- 分行签名
    ,replace(replace(t1.relres2,chr(13),''),chr(10),'')  -- 支行签名
    ,replace(replace(t1.relusr1,chr(13),''),chr(10),'')  -- 授权用户
    ,replace(replace(t1.relusr2,chr(13),''),chr(10),'')  -- 授权用户
    ,replace(replace(t1.relusr3,chr(13),''),chr(10),'')  -- 授权用户
    ,replace(replace(t1.imginr,chr(13),''),chr(10),'')  -- 图像inr
    ,replace(replace(t1.branchinr,chr(13),''),chr(10),'')  -- 业务所属支行INR
    ,replace(replace(t1.orgflg,chr(13),''),chr(10),'')  -- 机构标识
    ,replace(replace(t1.addtxt,chr(13),''),chr(10),'')  -- 附加信息
    ,replace(replace(t1.gylsh,chr(13),''),chr(10),'')  -- 核心柜员流水号
    ,replace(replace(t1.gylsh1,chr(13),''),chr(10),'')  -- 核心表外柜员流水号
    ,replace(replace(t1.yewgzh,chr(13),''),chr(10),'')  -- 业务跟踪号
    ,replace(replace(t1.cmtflg,chr(13),''),chr(10),'')  -- CMT100报文标识
    ,replace(replace(t1.ctrbnknum,chr(13),''),chr(10),'')  -- 对手行行号
    ,replace(replace(t1.ctrbnknam,chr(13),''),chr(10),'')  -- 对手行行名
    ,replace(replace(t1.qjls,chr(13),''),chr(10),'')  -- 全局流水号
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.isbs_trn t1    --交易流水
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'aml_isbs_trn',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);