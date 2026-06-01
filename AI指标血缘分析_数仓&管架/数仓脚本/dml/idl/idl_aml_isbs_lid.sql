/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_aml_isbs_lid
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
alter table ${idl_schema}.aml_isbs_lid drop partition p_${last_date};
alter table ${idl_schema}.aml_isbs_lid drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.aml_isbs_lid add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.aml_isbs_lid partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,inr  -- 进口信用证ID号
    ,ownref  -- 参考号
    ,nam  -- 标识交易的外部显示名称
    ,ownusr  -- 参考号
    ,credat  -- 开证或注册日期
    ,opndat  -- 开证日期
    ,clsdat  -- 结束日期
    ,advnam  -- 通知行名称
    ,advref  -- 通知行参考号
    ,amedat  -- 上次修改日期
    ,amenbr  -- 修改次数
    ,aplnam  -- 申请人名称
    ,aplref  -- 申请人参考号
    ,avbby  -- 指定方式
    ,avbwth  -- 指定方式
    ,bennam  -- 收益人名字
    ,benref  -- 受益人参考号
    ,chato  -- 费用流向
    ,cnfdet  -- 保兑状态
    ,expdat  -- 效期，指定信用证的效期
    ,expplc  -- 交单地点
    ,lcrtyp  -- 信用证的格式
    ,nomspc  -- 规格数量
    ,nomtop  -- 溢短装
    ,nomton  -- 溢短装
    ,preadvdt  -- 预通知日期
    ,rmbact  -- 偿付行用户帐号
    ,rmbcha  -- 偿付行费用
    ,rmbflg  -- 偿付标志
    ,shpdat  -- 装船日期
    ,shpfro  -- 装船地点
    ,porloa  -- 装货港
    ,pordis  -- 卸货港
    ,shppar  -- 分装
    ,shpto  -- 运货地点
    ,shptrs  -- 转载[SHPTRS]
    ,stacty  -- 国家代码
    ,stagod  -- 货物代码
    ,utlnbr  -- 利用数目
    ,advnbr  -- 通知次数
    ,redclsflg  -- 红/绿
    ,ver  -- 版本号
    ,lcityp  -- 信用证类型
    ,b2binr  -- 背对背信用证INR
    ,b2bref  -- 背对背信用证参考号
    ,revnbr  -- 循环实际次数
    ,revtimes  -- 循环允许最大次数
    ,revflg  -- 循环标志
    ,revawapl  -- 等待申请人回复标志
    ,revdat  -- 循环日期
    ,revcum  -- 累计记贷
    ,revtyp  -- 循环方式
    ,initpty  -- 申请人所在银行
    ,resflg  -- 预留标志
    ,apprul  -- 适用的惯例
    ,apprulrmb  -- 适用的偿付惯例
    ,apprultxt  -- 其他惯例
    ,autdat  -- 偿付日期
    ,etyextkey  -- 交易实体
    ,tenmaxday  -- 远期期限
    ,branchinr  -- 所属机构号
    ,bchkeyinr  -- 经办机构号
    ,decflg  -- 存在减额修改标志
    ,cshpct  -- 保证金应收比例
    ,isstyp  -- 发布类型
    ,fincod  -- 借据号
    ,fintyp  -- 业务品种
    ,relcshpct  -- 保证金实收比例
    ,jjh  -- 借据号
    ,dflg  -- 国内信用证标志
    ,guaflg  -- 押货标志
    ,tratyp  -- 运输方式
    ,opnamo  -- 信用证余额
    ,ameflg  -- 修改标志
    ,cretyp  -- 
    ,tadtyp  -- 
    ,shpins  -- 
    ,sermod  -- 
    ,serfro  -- 
    ,negflg  -- 
    ,comflg  -- 
    ,insdat  -- 
    ,shppars18  -- 装船日期
    ,shptrss18  -- 选择是否拆装
    ,spcbenflg  -- 受益人特殊付款条件标记
    ,spcrcbflg  -- 收款行特殊付款条件标记
    ,prepertxts18  -- 提示周期
    ,prepers18  -- 周期描述
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.inr,chr(13),''),chr(10),'')  -- 进口信用证ID号
    ,replace(replace(t1.ownref,chr(13),''),chr(10),'')  -- 参考号
    ,replace(replace(t1.nam,chr(13),''),chr(10),'')  -- 标识交易的外部显示名称
    ,replace(replace(t1.ownusr,chr(13),''),chr(10),'')  -- 参考号
    ,t1.credat  -- 开证或注册日期
    ,t1.opndat  -- 开证日期
    ,t1.clsdat  -- 结束日期
    ,replace(replace(t1.advnam,chr(13),''),chr(10),'')  -- 通知行名称
    ,replace(replace(t1.advref,chr(13),''),chr(10),'')  -- 通知行参考号
    ,t1.amedat  -- 上次修改日期
    ,t1.amenbr  -- 修改次数
    ,replace(replace(t1.aplnam,chr(13),''),chr(10),'')  -- 申请人名称
    ,replace(replace(t1.aplref,chr(13),''),chr(10),'')  -- 申请人参考号
    ,replace(replace(t1.avbby,chr(13),''),chr(10),'')  -- 指定方式
    ,replace(replace(t1.avbwth,chr(13),''),chr(10),'')  -- 指定方式
    ,replace(replace(t1.bennam,chr(13),''),chr(10),'')  -- 收益人名字
    ,replace(replace(t1.benref,chr(13),''),chr(10),'')  -- 受益人参考号
    ,replace(replace(t1.chato,chr(13),''),chr(10),'')  -- 费用流向
    ,replace(replace(t1.cnfdet,chr(13),''),chr(10),'')  -- 保兑状态
    ,t1.expdat  -- 效期，指定信用证的效期
    ,replace(replace(t1.expplc,chr(13),''),chr(10),'')  -- 交单地点
    ,replace(replace(t1.lcrtyp,chr(13),''),chr(10),'')  -- 信用证的格式
    ,replace(replace(t1.nomspc,chr(13),''),chr(10),'')  -- 规格数量
    ,t1.nomtop  -- 溢短装
    ,t1.nomton  -- 溢短装
    ,t1.preadvdt  -- 预通知日期
    ,replace(replace(t1.rmbact,chr(13),''),chr(10),'')  -- 偿付行用户帐号
    ,replace(replace(t1.rmbcha,chr(13),''),chr(10),'')  -- 偿付行费用
    ,replace(replace(t1.rmbflg,chr(13),''),chr(10),'')  -- 偿付标志
    ,t1.shpdat  -- 装船日期
    ,replace(replace(t1.shpfro,chr(13),''),chr(10),'')  -- 装船地点
    ,replace(replace(t1.porloa,chr(13),''),chr(10),'')  -- 装货港
    ,replace(replace(t1.pordis,chr(13),''),chr(10),'')  -- 卸货港
    ,replace(replace(t1.shppar,chr(13),''),chr(10),'')  -- 分装
    ,replace(replace(t1.shpto,chr(13),''),chr(10),'')  -- 运货地点
    ,replace(replace(t1.shptrs,chr(13),''),chr(10),'')  -- 转载[SHPTRS]
    ,replace(replace(t1.stacty,chr(13),''),chr(10),'')  -- 国家代码
    ,replace(replace(t1.stagod,chr(13),''),chr(10),'')  -- 货物代码
    ,t1.utlnbr  -- 利用数目
    ,t1.advnbr  -- 通知次数
    ,replace(replace(t1.redclsflg,chr(13),''),chr(10),'')  -- 红/绿
    ,replace(replace(t1.ver,chr(13),''),chr(10),'')  -- 版本号
    ,replace(replace(t1.lcityp,chr(13),''),chr(10),'')  -- 信用证类型
    ,replace(replace(t1.b2binr,chr(13),''),chr(10),'')  -- 背对背信用证INR
    ,replace(replace(t1.b2bref,chr(13),''),chr(10),'')  -- 背对背信用证参考号
    ,t1.revnbr  -- 循环实际次数
    ,t1.revtimes  -- 循环允许最大次数
    ,replace(replace(t1.revflg,chr(13),''),chr(10),'')  -- 循环标志
    ,replace(replace(t1.revawapl,chr(13),''),chr(10),'')  -- 等待申请人回复标志
    ,t1.revdat  -- 循环日期
    ,replace(replace(t1.revcum,chr(13),''),chr(10),'')  -- 累计记贷
    ,replace(replace(t1.revtyp,chr(13),''),chr(10),'')  -- 循环方式
    ,replace(replace(t1.initpty,chr(13),''),chr(10),'')  -- 申请人所在银行
    ,replace(replace(t1.resflg,chr(13),''),chr(10),'')  -- 预留标志
    ,replace(replace(t1.apprul,chr(13),''),chr(10),'')  -- 适用的惯例
    ,replace(replace(t1.apprulrmb,chr(13),''),chr(10),'')  -- 适用的偿付惯例
    ,replace(replace(t1.apprultxt,chr(13),''),chr(10),'')  -- 其他惯例
    ,t1.autdat  -- 偿付日期
    ,replace(replace(t1.etyextkey,chr(13),''),chr(10),'')  -- 交易实体
    ,t1.tenmaxday  -- 远期期限
    ,replace(replace(t1.branchinr,chr(13),''),chr(10),'')  -- 所属机构号
    ,replace(replace(t1.bchkeyinr,chr(13),''),chr(10),'')  -- 经办机构号
    ,replace(replace(t1.decflg,chr(13),''),chr(10),'')  -- 存在减额修改标志
    ,t1.cshpct  -- 保证金应收比例
    ,replace(replace(t1.isstyp,chr(13),''),chr(10),'')  -- 发布类型
    ,replace(replace(t1.fincod,chr(13),''),chr(10),'')  -- 借据号
    ,replace(replace(t1.fintyp,chr(13),''),chr(10),'')  -- 业务品种
    ,t1.relcshpct  -- 保证金实收比例
    ,replace(replace(t1.jjh,chr(13),''),chr(10),'')  -- 借据号
    ,replace(replace(t1.dflg,chr(13),''),chr(10),'')  -- 国内信用证标志
    ,replace(replace(t1.guaflg,chr(13),''),chr(10),'')  -- 押货标志
    ,replace(replace(t1.tratyp,chr(13),''),chr(10),'')  -- 运输方式
    ,t1.opnamo  -- 信用证余额
    ,replace(replace(t1.ameflg,chr(13),''),chr(10),'')  -- 修改标志
    ,replace(replace(t1.cretyp,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.tadtyp,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.shpins,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.sermod,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.serfro,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.negflg,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.comflg,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.insdat,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.shppars18,chr(13),''),chr(10),'')  -- 装船日期
    ,replace(replace(t1.shptrss18,chr(13),''),chr(10),'')  -- 选择是否拆装
    ,replace(replace(t1.spcbenflg,chr(13),''),chr(10),'')  -- 受益人特殊付款条件标记
    ,replace(replace(t1.spcrcbflg,chr(13),''),chr(10),'')  -- 收款行特殊付款条件标记
    ,replace(replace(t1.prepertxts18,chr(13),''),chr(10),'')  -- 提示周期
    ,t1.prepers18  -- 周期描述
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.isbs_lid t1    --进口信用证业务信息(存放短字节)
where t1.start_dt <=to_date('${batch_date}','yyyymmdd') and t1.end_dt >to_date('${batch_date}','yyyymmdd') and t1.id_mark <> 'D' ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'aml_isbs_lid',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);