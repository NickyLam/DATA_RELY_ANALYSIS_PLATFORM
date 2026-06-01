/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_aml_isbs_cpd
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
alter table ${idl_schema}.aml_isbs_cpd drop partition p_${last_date};
alter table ${idl_schema}.aml_isbs_cpd drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.aml_isbs_cpd add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.aml_isbs_cpd partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,inr  -- 唯一ID
    ,ownref  -- 交易参考号
    ,nam  -- 交易描述
    ,pyeptyinr  -- 收款人的INR
    ,pyeptainr  -- 收款人的地址
    ,pyenam  -- 收款人的描述
    ,pyeref  -- 收款人的参考号
    ,pybptyinr  -- 付款银行的INR
    ,pybptainr  -- 付款银行地址的INR
    ,pybnam  -- 付款银行名称
    ,pybref  -- 付款银行参考号
    ,orcptyinr  -- 汇款人PTYINR
    ,orcptainr  -- 汇款人PTAINR
    ,orcnam  -- 汇款人名称
    ,orcref  -- 汇款人参考号
    ,oriptyinr  -- 汇款行ptyinr
    ,oriptainr  -- 汇款行ptainr
    ,orinam  -- 汇款行名称
    ,oriref  -- 汇款行参考号
    ,valdat  -- 起息日
    ,opndat  -- 交易开始时间
    ,clsdat  -- 交易关闭时间
    ,chato  -- 费用
    ,credat  -- 建立日期
    ,ownusr  -- 操作用户
    ,ver  -- 版本号
    ,detchgcod  -- 详细费用
    ,paytyp  -- 付款类型
    ,stagod  -- 货物代码
    ,stacty  -- 国家代码
    ,etyextkey  -- 实体关键字
    ,sysno  -- 清算编号
    ,othbch  -- 所属行
    ,gors  -- 收款对象
    ,feecur  -- 国外费用币种
    ,feeamt  -- 国外费用金额
    ,trntyp  -- 汇款性质
    ,paytype  -- 汇款方式
    ,paydat  -- 付款日期
    ,clityp  -- 客户类型
    ,trdint  -- 结汇类型
    ,curf33b  -- 原始币种
    ,cur71f  -- 发报行扣费币种
    ,amt71f  -- 发报行扣费金额
    ,amtf33b  -- 原始金额
    ,f36  -- 汇率
    ,f23e  -- 指令代码
    ,f23b  -- 银行操作码
    ,trdout  -- 售汇类型
    ,swftyp  -- 报文类型
    ,trdinr  -- Trd表inr
    ,rel21  -- 参考号
    ,branchinr  -- 所属机构号
    ,bchkeyinr  -- 经办机构号
    ,accmod  -- 帐号类型
    ,sztyp  -- 收支类型
    ,sndbanref  -- 发报行原始编号
    ,orcact  -- 汇款人帐号
    ,pyeact  -- 收款人帐号
    ,canflg  -- 退汇标志
    ,nraflg  -- NRA标志
    ,qsqdbh  -- 清算渠道
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.inr,chr(13),''),chr(10),'')  -- 唯一ID
    ,replace(replace(t1.ownref,chr(13),''),chr(10),'')  -- 交易参考号
    ,replace(replace(t1.nam,chr(13),''),chr(10),'')  -- 交易描述
    ,replace(replace(t1.pyeptyinr,chr(13),''),chr(10),'')  -- 收款人的INR
    ,replace(replace(t1.pyeptainr,chr(13),''),chr(10),'')  -- 收款人的地址
    ,replace(replace(t1.pyenam,chr(13),''),chr(10),'')  -- 收款人的描述
    ,replace(replace(t1.pyeref,chr(13),''),chr(10),'')  -- 收款人的参考号
    ,replace(replace(t1.pybptyinr,chr(13),''),chr(10),'')  -- 付款银行的INR
    ,replace(replace(t1.pybptainr,chr(13),''),chr(10),'')  -- 付款银行地址的INR
    ,replace(replace(t1.pybnam,chr(13),''),chr(10),'')  -- 付款银行名称
    ,replace(replace(t1.pybref,chr(13),''),chr(10),'')  -- 付款银行参考号
    ,replace(replace(t1.orcptyinr,chr(13),''),chr(10),'')  -- 汇款人PTYINR
    ,replace(replace(t1.orcptainr,chr(13),''),chr(10),'')  -- 汇款人PTAINR
    ,replace(replace(t1.orcnam,chr(13),''),chr(10),'')  -- 汇款人名称
    ,replace(replace(t1.orcref,chr(13),''),chr(10),'')  -- 汇款人参考号
    ,replace(replace(t1.oriptyinr,chr(13),''),chr(10),'')  -- 汇款行ptyinr
    ,replace(replace(t1.oriptainr,chr(13),''),chr(10),'')  -- 汇款行ptainr
    ,replace(replace(t1.orinam,chr(13),''),chr(10),'')  -- 汇款行名称
    ,replace(replace(t1.oriref,chr(13),''),chr(10),'')  -- 汇款行参考号
    ,t1.valdat  -- 起息日
    ,t1.opndat  -- 交易开始时间
    ,t1.clsdat  -- 交易关闭时间
    ,replace(replace(t1.chato,chr(13),''),chr(10),'')  -- 费用
    ,t1.credat  -- 建立日期
    ,replace(replace(t1.ownusr,chr(13),''),chr(10),'')  -- 操作用户
    ,replace(replace(t1.ver,chr(13),''),chr(10),'')  -- 版本号
    ,replace(replace(t1.detchgcod,chr(13),''),chr(10),'')  -- 详细费用
    ,replace(replace(t1.paytyp,chr(13),''),chr(10),'')  -- 付款类型
    ,replace(replace(t1.stagod,chr(13),''),chr(10),'')  -- 货物代码
    ,replace(replace(t1.stacty,chr(13),''),chr(10),'')  -- 国家代码
    ,replace(replace(t1.etyextkey,chr(13),''),chr(10),'')  -- 实体关键字
    ,replace(replace(t1.sysno,chr(13),''),chr(10),'')  -- 清算编号
    ,replace(replace(t1.othbch,chr(13),''),chr(10),'')  -- 所属行
    ,replace(replace(t1.gors,chr(13),''),chr(10),'')  -- 收款对象
    ,replace(replace(t1.feecur,chr(13),''),chr(10),'')  -- 国外费用币种
    ,t1.feeamt  -- 国外费用金额
    ,replace(replace(t1.trntyp,chr(13),''),chr(10),'')  -- 汇款性质
    ,replace(replace(t1.paytype,chr(13),''),chr(10),'')  -- 汇款方式
    ,t1.paydat  -- 付款日期
    ,replace(replace(t1.clityp,chr(13),''),chr(10),'')  -- 客户类型
    ,replace(replace(t1.trdint,chr(13),''),chr(10),'')  -- 结汇类型
    ,replace(replace(t1.curf33b,chr(13),''),chr(10),'')  -- 原始币种
    ,replace(replace(t1.cur71f,chr(13),''),chr(10),'')  -- 发报行扣费币种
    ,t1.amt71f  -- 发报行扣费金额
    ,t1.amtf33b  -- 原始金额
    ,t1.f36  -- 汇率
    ,replace(replace(t1.f23e,chr(13),''),chr(10),'')  -- 指令代码
    ,replace(replace(t1.f23b,chr(13),''),chr(10),'')  -- 银行操作码
    ,replace(replace(t1.trdout,chr(13),''),chr(10),'')  -- 售汇类型
    ,replace(replace(t1.swftyp,chr(13),''),chr(10),'')  -- 报文类型
    ,replace(replace(t1.trdinr,chr(13),''),chr(10),'')  -- Trd表inr
    ,replace(replace(t1.rel21,chr(13),''),chr(10),'')  -- 参考号
    ,replace(replace(t1.branchinr,chr(13),''),chr(10),'')  -- 所属机构号
    ,replace(replace(t1.bchkeyinr,chr(13),''),chr(10),'')  -- 经办机构号
    ,replace(replace(t1.accmod,chr(13),''),chr(10),'')  -- 帐号类型
    ,replace(replace(t1.sztyp,chr(13),''),chr(10),'')  -- 收支类型
    ,replace(replace(t1.sndbanref,chr(13),''),chr(10),'')  -- 发报行原始编号
    ,replace(replace(t1.orcact,chr(13),''),chr(10),'')  -- 汇款人帐号
    ,replace(replace(t1.pyeact,chr(13),''),chr(10),'')  -- 收款人帐号
    ,replace(replace(t1.canflg,chr(13),''),chr(10),'')  -- 退汇标志
    ,replace(replace(t1.nraflg,chr(13),''),chr(10),'')  -- NRA标志
    ,replace(replace(t1.qsqdbh,chr(13),''),chr(10),'')  -- 清算渠道
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.isbs_cpd t1    --汇款业务信息(存放短字节)
where t1.start_dt <=to_date('${batch_date}','yyyymmdd') and t1.end_dt >to_date('${batch_date}','yyyymmdd') and t1.id_mark <> 'D' ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'aml_isbs_cpd',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);