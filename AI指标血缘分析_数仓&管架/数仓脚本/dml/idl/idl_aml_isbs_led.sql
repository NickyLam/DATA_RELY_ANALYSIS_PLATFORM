/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_aml_isbs_led
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
alter table ${idl_schema}.aml_isbs_led drop partition p_${last_date};
alter table ${idl_schema}.aml_isbs_led drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.aml_isbs_led add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.aml_isbs_led partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,inr  -- 出口信用证ID号
    ,ownref  -- 参考号
    ,nam  -- 标识交易的外部显示名称
    ,ownusr  -- 经办人
    ,credat  -- 创建日期
    ,opndat  -- 开证日期, 指定信用证被开证行开出的日期
    ,clsdat  -- 关闭日期
    ,cnfdat  -- 保兑日
    ,advdat  -- 通知日期
    ,issnam  -- 开证行
    ,issref  -- 开证行参考号
    ,amedat  -- 修改日期
    ,amenbr  -- 修改次数
    ,avbby  -- 单据处理方式
    ,avbwth  -- 单据处理行
    ,bennam  -- 受益人
    ,benref  -- 受益人参考号
    ,chato  -- 费用分担
    ,cnfflg  -- 承兑类型
    ,cnfdet  -- 开证行保兑状态
    ,cnfsta  -- 保兑状态’Y’,’S’,’ ’
    ,expdat  -- 出口日期
    ,expplc  -- 交易完成地点
    ,lcrtyp  -- 付款种类
    ,nomspc  -- 溢短装标志。
    ,nomtop  -- 溢短装-正
    ,nomton  -- 溢短装-负
    ,preadvdt  -- 预通知日期
    ,shpdat  -- 装船日期，指定装船的最后日期
    ,shpfro  -- 装船地点
    ,shppar  -- 运货地点
    ,shpto  -- 运货地点
    ,shptrs  -- 转载
    ,stacty  -- 国家代码
    ,stagod  -- 货物代码
    ,utlnbr  -- 利用数目
    ,ver  -- 版本号
    ,aplbnkdirsnd  -- 是否立即发送
    ,tenmaxday  -- 最大期限
    ,cnfsnd  -- 第一通知行保兑状态
    ,revflg  -- 循环标志
    ,revnbr  -- 循环信用证号
    ,revtimes  -- 循环次数
    ,revdat  -- 到单日
    ,revcum  -- 累计记贷
    ,revtyp  -- 循环类型
    ,cnfins  -- 发给第二通知行确认栏位
    ,redclsflg  -- 红/绿 条款
    ,advnbr  -- 通知次数
    ,resflg  -- 预留标志
    ,inctrf  -- 开入的装让标志
    ,apprul  -- 适用的条款
    ,apprultxt  -- 其他适用的条款
    ,pordis  -- 卸货港口
    ,porloa  -- 部分装船
    ,nonban  -- 与银行无关的开证人标志
    ,etyextkey  -- 默认/初始用户ID
    ,partcon  -- 保兑百分比
    ,collflg  -- 信用证抵押标志位
    ,teskeyunc  -- 检验是否确认
    ,dbtflg  -- 记入借方授权标志
    ,branchinr  -- 所属机构号
    ,bchkeyinr  -- 经办机构号
    ,rskrat  -- 风险额度占用率
    ,dflg  -- dflg
    ,tratyp  -- 运输方式
    ,negflg  -- 
    ,shppars18  -- 装船日期
    ,prepers18  -- 周期描述
    ,prepertxts18  -- 提示周期
    ,shptrss18  -- 选择是否拆装
    ,spcbenflg  -- 受益人特殊付款条件标记
    ,spcrcbflg  -- 收款行特殊付款条件标记
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.inr,chr(13),''),chr(10),'')  -- 出口信用证ID号
    ,replace(replace(t1.ownref,chr(13),''),chr(10),'')  -- 参考号
    ,replace(replace(t1.nam,chr(13),''),chr(10),'')  -- 标识交易的外部显示名称
    ,replace(replace(t1.ownusr,chr(13),''),chr(10),'')  -- 经办人
    ,t1.credat  -- 创建日期
    ,t1.opndat  -- 开证日期, 指定信用证被开证行开出的日期
    ,t1.clsdat  -- 关闭日期
    ,t1.cnfdat  -- 保兑日
    ,t1.advdat  -- 通知日期
    ,replace(replace(t1.issnam,chr(13),''),chr(10),'')  -- 开证行
    ,replace(replace(t1.issref,chr(13),''),chr(10),'')  -- 开证行参考号
    ,t1.amedat  -- 修改日期
    ,t1.amenbr  -- 修改次数
    ,replace(replace(t1.avbby,chr(13),''),chr(10),'')  -- 单据处理方式
    ,replace(replace(t1.avbwth,chr(13),''),chr(10),'')  -- 单据处理行
    ,replace(replace(t1.bennam,chr(13),''),chr(10),'')  -- 受益人
    ,replace(replace(t1.benref,chr(13),''),chr(10),'')  -- 受益人参考号
    ,replace(replace(t1.chato,chr(13),''),chr(10),'')  -- 费用分担
    ,replace(replace(t1.cnfflg,chr(13),''),chr(10),'')  -- 承兑类型
    ,replace(replace(t1.cnfdet,chr(13),''),chr(10),'')  -- 开证行保兑状态
    ,replace(replace(t1.cnfsta,chr(13),''),chr(10),'')  -- 保兑状态’Y’,’S’,’ ’
    ,t1.expdat  -- 出口日期
    ,replace(replace(t1.expplc,chr(13),''),chr(10),'')  -- 交易完成地点
    ,replace(replace(t1.lcrtyp,chr(13),''),chr(10),'')  -- 付款种类
    ,replace(replace(t1.nomspc,chr(13),''),chr(10),'')  -- 溢短装标志。
    ,t1.nomtop  -- 溢短装-正
    ,t1.nomton  -- 溢短装-负
    ,t1.preadvdt  -- 预通知日期
    ,t1.shpdat  -- 装船日期，指定装船的最后日期
    ,replace(replace(t1.shpfro,chr(13),''),chr(10),'')  -- 装船地点
    ,replace(replace(t1.shppar,chr(13),''),chr(10),'')  -- 运货地点
    ,replace(replace(t1.shpto,chr(13),''),chr(10),'')  -- 运货地点
    ,replace(replace(t1.shptrs,chr(13),''),chr(10),'')  -- 转载
    ,replace(replace(t1.stacty,chr(13),''),chr(10),'')  -- 国家代码
    ,replace(replace(t1.stagod,chr(13),''),chr(10),'')  -- 货物代码
    ,t1.utlnbr  -- 利用数目
    ,replace(replace(t1.ver,chr(13),''),chr(10),'')  -- 版本号
    ,replace(replace(t1.aplbnkdirsnd,chr(13),''),chr(10),'')  -- 是否立即发送
    ,t1.tenmaxday  -- 最大期限
    ,replace(replace(t1.cnfsnd,chr(13),''),chr(10),'')  -- 第一通知行保兑状态
    ,replace(replace(t1.revflg,chr(13),''),chr(10),'')  -- 循环标志
    ,t1.revnbr  -- 循环信用证号
    ,t1.revtimes  -- 循环次数
    ,t1.revdat  -- 到单日
    ,replace(replace(t1.revcum,chr(13),''),chr(10),'')  -- 累计记贷
    ,replace(replace(t1.revtyp,chr(13),''),chr(10),'')  -- 循环类型
    ,replace(replace(t1.cnfins,chr(13),''),chr(10),'')  -- 发给第二通知行确认栏位
    ,replace(replace(t1.redclsflg,chr(13),''),chr(10),'')  -- 红/绿 条款
    ,t1.advnbr  -- 通知次数
    ,replace(replace(t1.resflg,chr(13),''),chr(10),'')  -- 预留标志
    ,replace(replace(t1.inctrf,chr(13),''),chr(10),'')  -- 开入的装让标志
    ,replace(replace(t1.apprul,chr(13),''),chr(10),'')  -- 适用的条款
    ,replace(replace(t1.apprultxt,chr(13),''),chr(10),'')  -- 其他适用的条款
    ,replace(replace(t1.pordis,chr(13),''),chr(10),'')  -- 卸货港口
    ,replace(replace(t1.porloa,chr(13),''),chr(10),'')  -- 部分装船
    ,replace(replace(t1.nonban,chr(13),''),chr(10),'')  -- 与银行无关的开证人标志
    ,replace(replace(t1.etyextkey,chr(13),''),chr(10),'')  -- 默认/初始用户ID
    ,t1.partcon  -- 保兑百分比
    ,replace(replace(t1.collflg,chr(13),''),chr(10),'')  -- 信用证抵押标志位
    ,replace(replace(t1.teskeyunc,chr(13),''),chr(10),'')  -- 检验是否确认
    ,replace(replace(t1.dbtflg,chr(13),''),chr(10),'')  -- 记入借方授权标志
    ,replace(replace(t1.branchinr,chr(13),''),chr(10),'')  -- 所属机构号
    ,replace(replace(t1.bchkeyinr,chr(13),''),chr(10),'')  -- 经办机构号
    ,t1.rskrat  -- 风险额度占用率
    ,replace(replace(t1.dflg,chr(13),''),chr(10),'')  -- dflg
    ,replace(replace(t1.tratyp,chr(13),''),chr(10),'')  -- 运输方式
    ,replace(replace(t1.negflg,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.shppars18,chr(13),''),chr(10),'')  -- 装船日期
    ,t1.prepers18  -- 周期描述
    ,replace(replace(t1.prepertxts18,chr(13),''),chr(10),'')  -- 提示周期
    ,replace(replace(t1.shptrss18,chr(13),''),chr(10),'')  -- 选择是否拆装
    ,replace(replace(t1.spcbenflg,chr(13),''),chr(10),'')  -- 受益人特殊付款条件标记
    ,replace(replace(t1.spcrcbflg,chr(13),''),chr(10),'')  -- 收款行特殊付款条件标记
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.isbs_led t1    --出口信用证业务信息(存放短字节)
where t1.start_dt <=to_date('${batch_date}','yyyymmdd') and t1.end_dt >to_date('${batch_date}','yyyymmdd') and t1.id_mark <> 'D' ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'aml_isbs_led',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);