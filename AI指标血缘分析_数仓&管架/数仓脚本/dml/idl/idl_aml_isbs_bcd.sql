/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_aml_isbs_bcd
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
alter table ${idl_schema}.aml_isbs_bcd drop partition p_${last_date};
alter table ${idl_schema}.aml_isbs_bcd drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.aml_isbs_bcd add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.aml_isbs_bcd partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,inr  -- 唯一ID号
    ,ownref  -- 参考号
    ,nam  -- 交易名称
    ,relgodflg  -- 货物授权标志
    ,relgoddat  -- 货物到达日期
    ,rcvdat  -- 收货日期
    ,predat  -- 提示日期
    ,shpdat  -- 发船日期
    ,credat  -- 进口代收产生日期
    ,advdat  -- 单据已到的通知日期
    ,clsdat  -- 到期日期
    ,matdat  -- 效期到期日
    ,opndat  -- 开证日期
    ,doctypcod  -- 拒付/收货的代码
    ,matperbeg  -- 效期起始日
    ,matpercnt  -- 效期天数
    ,matpertyp  -- 日期的类型
    ,ownusr  -- 负责人
    ,ver  -- 版本号
    ,trpdoctyp  -- 传送单据类型
    ,trpdocnum  -- 单据编号
    ,tradat  -- 发单日期
    ,tramod  -- 发单方式
    ,shpfro  -- 发货地点
    ,shpto  -- 到货地点
    ,chato  -- 付款方向
    ,othins  -- 延期付款
    ,stacty  -- 国家代码
    ,stagod  -- 货物代码
    ,accdat  -- 承兑日期
    ,amenbr  -- 修改次数
    ,dftgarflg  -- 担保标志
    ,reltyp  -- release类型
    ,expdat  -- 运输担保到期日
    ,rtodreflg  -- 放货标志
    ,mattxtflg  -- 混合付款标志
    ,focflg  -- 免付款交单标志
    ,waicolcod  -- 代收行费用遭拒付时是否放弃
    ,wairmtcod  -- 我方费用遭拒付时是否放弃
    ,oridre  -- 发送面函标志
    ,docsta  -- 单据状态
    ,resflg  -- 预留标志
    ,agtdat  -- 提货日期
    ,etyextkey  -- 用户组别关键字
    ,proins  -- 拒付说明
    ,branchinr  -- 所属机构号
    ,bchkeyinr  -- 经办机构号
    ,nraflg  -- NRA收款标志
    ,qsqdbh  -- 清算渠道
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.inr,chr(13),''),chr(10),'')  -- 唯一ID号
    ,replace(replace(t1.ownref,chr(13),''),chr(10),'')  -- 参考号
    ,replace(replace(t1.nam,chr(13),''),chr(10),'')  -- 交易名称
    ,replace(replace(t1.relgodflg,chr(13),''),chr(10),'')  -- 货物授权标志
    ,t1.relgoddat  -- 货物到达日期
    ,t1.rcvdat  -- 收货日期
    ,t1.predat  -- 提示日期
    ,t1.shpdat  -- 发船日期
    ,t1.credat  -- 进口代收产生日期
    ,t1.advdat  -- 单据已到的通知日期
    ,t1.clsdat  -- 到期日期
    ,t1.matdat  -- 效期到期日
    ,t1.opndat  -- 开证日期
    ,replace(replace(t1.doctypcod,chr(13),''),chr(10),'')  -- 拒付/收货的代码
    ,replace(replace(t1.matperbeg,chr(13),''),chr(10),'')  -- 效期起始日
    ,t1.matpercnt  -- 效期天数
    ,replace(replace(t1.matpertyp,chr(13),''),chr(10),'')  -- 日期的类型
    ,replace(replace(t1.ownusr,chr(13),''),chr(10),'')  -- 负责人
    ,replace(replace(t1.ver,chr(13),''),chr(10),'')  -- 版本号
    ,replace(replace(t1.trpdoctyp,chr(13),''),chr(10),'')  -- 传送单据类型
    ,replace(replace(t1.trpdocnum,chr(13),''),chr(10),'')  -- 单据编号
    ,t1.tradat  -- 发单日期
    ,replace(replace(t1.tramod,chr(13),''),chr(10),'')  -- 发单方式
    ,replace(replace(t1.shpfro,chr(13),''),chr(10),'')  -- 发货地点
    ,replace(replace(t1.shpto,chr(13),''),chr(10),'')  -- 到货地点
    ,replace(replace(t1.chato,chr(13),''),chr(10),'')  -- 付款方向
    ,replace(replace(t1.othins,chr(13),''),chr(10),'')  -- 延期付款
    ,replace(replace(t1.stacty,chr(13),''),chr(10),'')  -- 国家代码
    ,replace(replace(t1.stagod,chr(13),''),chr(10),'')  -- 货物代码
    ,t1.accdat  -- 承兑日期
    ,t1.amenbr  -- 修改次数
    ,replace(replace(t1.dftgarflg,chr(13),''),chr(10),'')  -- 担保标志
    ,replace(replace(t1.reltyp,chr(13),''),chr(10),'')  -- release类型
    ,t1.expdat  -- 运输担保到期日
    ,replace(replace(t1.rtodreflg,chr(13),''),chr(10),'')  -- 放货标志
    ,replace(replace(t1.mattxtflg,chr(13),''),chr(10),'')  -- 混合付款标志
    ,replace(replace(t1.focflg,chr(13),''),chr(10),'')  -- 免付款交单标志
    ,replace(replace(t1.waicolcod,chr(13),''),chr(10),'')  -- 代收行费用遭拒付时是否放弃
    ,replace(replace(t1.wairmtcod,chr(13),''),chr(10),'')  -- 我方费用遭拒付时是否放弃
    ,replace(replace(t1.oridre,chr(13),''),chr(10),'')  -- 发送面函标志
    ,replace(replace(t1.docsta,chr(13),''),chr(10),'')  -- 单据状态
    ,replace(replace(t1.resflg,chr(13),''),chr(10),'')  -- 预留标志
    ,t1.agtdat  -- 提货日期
    ,replace(replace(t1.etyextkey,chr(13),''),chr(10),'')  -- 用户组别关键字
    ,replace(replace(t1.proins,chr(13),''),chr(10),'')  -- 拒付说明
    ,replace(replace(t1.branchinr,chr(13),''),chr(10),'')  -- 所属机构号
    ,replace(replace(t1.bchkeyinr,chr(13),''),chr(10),'')  -- 经办机构号
    ,replace(replace(t1.nraflg,chr(13),''),chr(10),'')  -- NRA收款标志
    ,replace(replace(t1.qsqdbh,chr(13),''),chr(10),'')  -- 清算渠道
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.isbs_bcd t1    --进口代收业务信息(存放短字节内容)
where t1.start_dt <=to_date('${batch_date}','yyyymmdd') and t1.end_dt >to_date('${batch_date}','yyyymmdd') and t1.id_mark <> 'D' ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'aml_isbs_bcd',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);