/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_aml_isbs_bed
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
alter table ${idl_schema}.aml_isbs_bed drop partition p_${last_date};
alter table ${idl_schema}.aml_isbs_bed drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.aml_isbs_bed add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.aml_isbs_bed partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,inr  -- 出口单据ID
    ,ownref  -- 参考号
    ,nam  -- 交易名称
    ,pnttyp  -- 父类交易类型
    ,pntinr  -- 父交易
    ,predat  -- 提示日期
    ,rcvdat  -- 到单日期
    ,shpdat  -- 装船日期
    ,advdat  -- 通知日期
    ,matdat  -- 效期终止日期
    ,doctypcod  -- 单据类型
    ,opndat  -- 开始日期
    ,clsdat  -- 结束日期
    ,credat  -- 开证日期
    ,ownusr  -- 负责人
    ,ver  -- 版本号
    ,approvcod  -- 凭保议付标志
    ,frepayflg  -- 无偿放单标志
    ,docprbrol  -- 出单人
    ,payrol  -- 付款人
    ,orddat  -- 保证金信件收到日
    ,mattxtflg  -- 混合付款标志
    ,dscinsflg  -- 不符点标志
    ,acpnowflg  -- 现在承兑标志
    ,advtyp  -- 收到通知类型
    ,disdat  -- 不符点通知时间
    ,totcur  -- 付款货币
    ,totamt  -- 付款总金额
    ,totdat  -- 付款时间
    ,docsta  -- 单据状态
    ,docrol  -- 单据接受者
    ,docrolflg  -- 送单到其他地址标志
    ,dta770snd  -- 回执信息发送时间
    ,advdocflg  -- 返还单据标志
    ,etyextkey  -- 用户所在组的关键字
    ,rmbrol  -- 偿付行
    ,lescom  -- 国外扣费
    ,bchkeyinr  -- 经办机构号
    ,branchinr  -- 所属机构号
    ,nraflg  -- NRA付款标志
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.inr,chr(13),''),chr(10),'')  -- 出口单据ID
    ,replace(replace(t1.ownref,chr(13),''),chr(10),'')  -- 参考号
    ,replace(replace(t1.nam,chr(13),''),chr(10),'')  -- 交易名称
    ,replace(replace(t1.pnttyp,chr(13),''),chr(10),'')  -- 父类交易类型
    ,replace(replace(t1.pntinr,chr(13),''),chr(10),'')  -- 父交易
    ,t1.predat  -- 提示日期
    ,t1.rcvdat  -- 到单日期
    ,t1.shpdat  -- 装船日期
    ,t1.advdat  -- 通知日期
    ,t1.matdat  -- 效期终止日期
    ,replace(replace(t1.doctypcod,chr(13),''),chr(10),'')  -- 单据类型
    ,t1.opndat  -- 开始日期
    ,t1.clsdat  -- 结束日期
    ,t1.credat  -- 开证日期
    ,replace(replace(t1.ownusr,chr(13),''),chr(10),'')  -- 负责人
    ,replace(replace(t1.ver,chr(13),''),chr(10),'')  -- 版本号
    ,replace(replace(t1.approvcod,chr(13),''),chr(10),'')  -- 凭保议付标志
    ,replace(replace(t1.frepayflg,chr(13),''),chr(10),'')  -- 无偿放单标志
    ,replace(replace(t1.docprbrol,chr(13),''),chr(10),'')  -- 出单人
    ,replace(replace(t1.payrol,chr(13),''),chr(10),'')  -- 付款人
    ,t1.orddat  -- 保证金信件收到日
    ,replace(replace(t1.mattxtflg,chr(13),''),chr(10),'')  -- 混合付款标志
    ,replace(replace(t1.dscinsflg,chr(13),''),chr(10),'')  -- 不符点标志
    ,replace(replace(t1.acpnowflg,chr(13),''),chr(10),'')  -- 现在承兑标志
    ,replace(replace(t1.advtyp,chr(13),''),chr(10),'')  -- 收到通知类型
    ,t1.disdat  -- 不符点通知时间
    ,replace(replace(t1.totcur,chr(13),''),chr(10),'')  -- 付款货币
    ,t1.totamt  -- 付款总金额
    ,t1.totdat  -- 付款时间
    ,replace(replace(t1.docsta,chr(13),''),chr(10),'')  -- 单据状态
    ,replace(replace(t1.docrol,chr(13),''),chr(10),'')  -- 单据接受者
    ,replace(replace(t1.docrolflg,chr(13),''),chr(10),'')  -- 送单到其他地址标志
    ,t1.dta770snd  -- 回执信息发送时间
    ,replace(replace(t1.advdocflg,chr(13),''),chr(10),'')  -- 返还单据标志
    ,replace(replace(t1.etyextkey,chr(13),''),chr(10),'')  -- 用户所在组的关键字
    ,replace(replace(t1.rmbrol,chr(13),''),chr(10),'')  -- 偿付行
    ,t1.lescom  -- 国外扣费
    ,replace(replace(t1.bchkeyinr,chr(13),''),chr(10),'')  -- 经办机构号
    ,replace(replace(t1.branchinr,chr(13),''),chr(10),'')  -- 所属机构号
    ,replace(replace(t1.nraflg,chr(13),''),chr(10),'')  -- NRA付款标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.isbs_bed t1    --出口信用证下单据信息(存放短字节内容)
where t1.start_dt <=to_date('${batch_date}','yyyymmdd') and t1.end_dt >to_date('${batch_date}','yyyymmdd') and t1.id_mark <> 'D' ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'aml_isbs_bed',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);