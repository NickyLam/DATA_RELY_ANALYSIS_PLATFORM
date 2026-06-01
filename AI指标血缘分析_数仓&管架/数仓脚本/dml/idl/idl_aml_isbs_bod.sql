/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_aml_isbs_bod
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
alter table ${idl_schema}.aml_isbs_bod drop partition p_${last_date};
alter table ${idl_schema}.aml_isbs_bod drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.aml_isbs_bod add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.aml_isbs_bod partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,inr  -- 出口托收INR号
    ,ownref  -- 参考号
    ,nam  -- 交易名
    ,agtref  -- 代理商参考号
    ,agtact  -- 代理帐号
    ,agtcom  -- 代理委托
    ,shpdat  -- 装船日期
    ,predat  -- 提示日期
    ,rcvdat  -- 到单日期
    ,opndat  -- 寄单日期
    ,advdat  -- 通知日期
    ,matdat  -- 效期
    ,clsdat  -- 到期日
    ,doctypcod  -- 拒单/收单
    ,matperbeg  -- 完备期起始日
    ,matpercnt  -- 效期天数
    ,matpertyp  -- 效期类型
    ,trpdoctyp  -- 传送类型
    ,trpdocnum  -- 运输单据编号
    ,tradat  -- 传送日期
    ,tramod  -- 传送类型
    ,shpfro  -- 发货地点
    ,shpto  -- 到货地点
    ,waicolcod  -- 代收行费用遭拒付时是否放弃
    ,wairmtcod  -- 我方费用遭拒付时是否放弃
    ,chato  -- 付款方向
    ,stacty  -- 国家代码
    ,stagod  -- 货物类型
    ,credat  -- 创建日期
    ,ownusr  -- 负责人
    ,ver  -- 版本号
    ,focflg  -- 免付款交单标志
    ,dircolflg  -- 直接托收标志
    ,ccdpurflg  -- 是否低于预留金额付款
    ,ccdndrflg  -- 是否托收行保管单据
    ,issdat  -- 开立日期
    ,paydocnum  -- 单据数量
    ,paydoctyp  -- 单据类型
    ,mattxtflg  -- 混合付款标志
    ,othins  -- 延期时间
    ,docsta  -- 单据状态
    ,resflg  -- 预留标志
    ,amenbr  -- 修改次数
    ,msgrol  -- 第二接收行
    ,etyextkey  -- 实体
    ,lescom  -- 海外扣费
    ,branchinr  -- 所属机构号
    ,bchkeyinr  -- 经办机构号
    ,nraflg  -- NRA付款标志
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.inr,chr(13),''),chr(10),'')  -- 出口托收INR号
    ,replace(replace(t1.ownref,chr(13),''),chr(10),'')  -- 参考号
    ,replace(replace(t1.nam,chr(13),''),chr(10),'')  -- 交易名
    ,replace(replace(t1.agtref,chr(13),''),chr(10),'')  -- 代理商参考号
    ,replace(replace(t1.agtact,chr(13),''),chr(10),'')  -- 代理帐号
    ,replace(replace(t1.agtcom,chr(13),''),chr(10),'')  -- 代理委托
    ,t1.shpdat  -- 装船日期
    ,t1.predat  -- 提示日期
    ,t1.rcvdat  -- 到单日期
    ,t1.opndat  -- 寄单日期
    ,t1.advdat  -- 通知日期
    ,t1.matdat  -- 效期
    ,t1.clsdat  -- 到期日
    ,replace(replace(t1.doctypcod,chr(13),''),chr(10),'')  -- 拒单/收单
    ,replace(replace(t1.matperbeg,chr(13),''),chr(10),'')  -- 完备期起始日
    ,t1.matpercnt  -- 效期天数
    ,replace(replace(t1.matpertyp,chr(13),''),chr(10),'')  -- 效期类型
    ,replace(replace(t1.trpdoctyp,chr(13),''),chr(10),'')  -- 传送类型
    ,replace(replace(t1.trpdocnum,chr(13),''),chr(10),'')  -- 运输单据编号
    ,t1.tradat  -- 传送日期
    ,replace(replace(t1.tramod,chr(13),''),chr(10),'')  -- 传送类型
    ,replace(replace(t1.shpfro,chr(13),''),chr(10),'')  -- 发货地点
    ,replace(replace(t1.shpto,chr(13),''),chr(10),'')  -- 到货地点
    ,replace(replace(t1.waicolcod,chr(13),''),chr(10),'')  -- 代收行费用遭拒付时是否放弃
    ,replace(replace(t1.wairmtcod,chr(13),''),chr(10),'')  -- 我方费用遭拒付时是否放弃
    ,replace(replace(t1.chato,chr(13),''),chr(10),'')  -- 付款方向
    ,replace(replace(t1.stacty,chr(13),''),chr(10),'')  -- 国家代码
    ,replace(replace(t1.stagod,chr(13),''),chr(10),'')  -- 货物类型
    ,t1.credat  -- 创建日期
    ,replace(replace(t1.ownusr,chr(13),''),chr(10),'')  -- 负责人
    ,replace(replace(t1.ver,chr(13),''),chr(10),'')  -- 版本号
    ,replace(replace(t1.focflg,chr(13),''),chr(10),'')  -- 免付款交单标志
    ,replace(replace(t1.dircolflg,chr(13),''),chr(10),'')  -- 直接托收标志
    ,replace(replace(t1.ccdpurflg,chr(13),''),chr(10),'')  -- 是否低于预留金额付款
    ,replace(replace(t1.ccdndrflg,chr(13),''),chr(10),'')  -- 是否托收行保管单据
    ,t1.issdat  -- 开立日期
    ,replace(replace(t1.paydocnum,chr(13),''),chr(10),'')  -- 单据数量
    ,replace(replace(t1.paydoctyp,chr(13),''),chr(10),'')  -- 单据类型
    ,replace(replace(t1.mattxtflg,chr(13),''),chr(10),'')  -- 混合付款标志
    ,replace(replace(t1.othins,chr(13),''),chr(10),'')  -- 延期时间
    ,replace(replace(t1.docsta,chr(13),''),chr(10),'')  -- 单据状态
    ,replace(replace(t1.resflg,chr(13),''),chr(10),'')  -- 预留标志
    ,t1.amenbr  -- 修改次数
    ,replace(replace(t1.msgrol,chr(13),''),chr(10),'')  -- 第二接收行
    ,replace(replace(t1.etyextkey,chr(13),''),chr(10),'')  -- 实体
    ,t1.lescom  -- 海外扣费
    ,replace(replace(t1.branchinr,chr(13),''),chr(10),'')  -- 所属机构号
    ,replace(replace(t1.bchkeyinr,chr(13),''),chr(10),'')  -- 经办机构号
    ,replace(replace(t1.nraflg,chr(13),''),chr(10),'')  -- NRA付款标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.isbs_bod t1    --出口托收业务信息(存放短字节内容)
where t1.start_dt <=to_date('${batch_date}','yyyymmdd') and t1.end_dt >to_date('${batch_date}','yyyymmdd') and t1.id_mark <> 'D' ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'aml_isbs_bod',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);