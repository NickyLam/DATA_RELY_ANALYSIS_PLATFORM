/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_aml_isbs_gid
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
alter table ${idl_schema}.aml_isbs_gid drop partition p_${last_date};
alter table ${idl_schema}.aml_isbs_gid drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.aml_isbs_gid add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.aml_isbs_gid partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,inr  -- 保函内部ID号
    ,ownref  -- 参考号
    ,nam  -- 交易名称
    ,ownusr  -- 负责人
    ,credat  -- 创建日期
    ,opndat  -- 保函生效日，定义保函有效的开始日期
    ,clsdat  -- 结束日期
    ,oldref  -- 以前的业务号
    ,amedat  -- 最后一次修改日期
    ,orddat  -- 客户订单日期
    ,amenbr  -- 修改次数
    ,pndclm  -- 为决的索偿次数
    ,chato  -- 费用流向，保函开立GITOPN交易中业务人员手工选择                                                                          1. On applicant side      赋值U                                                                                                                 2.On beneficariy side   赋值B                                                                                                      3.Other  赋值O
    ,expdat  -- 保函的到期日，定义保函的期满日期
    ,liadat  -- liability定义负载的有效期
    ,stacty  -- Country Code
    ,ver  -- 版本号
    ,hndtyp  -- 保函开立类型
    ,gidtxtmodflg  -- 修改交易文本
    ,gtxinr  -- 产生文本INR
    ,giduil  -- 语言
    ,expflg  -- 效期标志
    ,liaflg  -- 选择赋值X,不选赋值空
    ,orcdat  -- 初始交易日期, 显示初始保函的日期
    ,orcref  -- 合同号
    ,orccur  -- 初始交易币种
    ,orcamt  -- 初始交易金额
    ,orcrat  -- 初始交易汇率
    ,sndto  -- 保函发给
    ,purcan  -- 取消原因
    ,tenref  -- 
    ,tendat  -- 
    ,avidat  -- 
    ,tenclsdat  -- 
    ,decrea  -- 
    ,jurplc  -- 权限位置
    ,jurlaw  -- 
    ,acc  -- 预付款帐号
    ,resflg  -- 预留标志
    ,stagod  -- 货物代号
    ,redamt  -- 减额
    ,redcur  -- 减额币种
    ,reddat  -- 减额日期
    ,outcur  -- 余额币种
    ,outamt  -- 余额
    ,cnfsta  -- 承兑状态
    ,partcon  -- 部分承兑
    ,cnfdat  -- 开立日期
    ,cnfflg  -- 按百分比还是金额承兑的标志
    ,revflg  -- 声明索偿标志位
    ,etyextkey  -- 实体交易
    ,gartyp  -- 保函类型
    ,trmdat  -- 上次发送日
    ,legfrm  -- 所遵循的国际惯例
    ,inudat  -- 生效日
    ,feecoldat  -- 收费日期
    ,bchkeyinr  -- 经办机构号
    ,branchinr  -- 所属机构号
    ,teskeyunc  -- 测试标志
    ,juscod  -- 组织机构
    ,cunqii  -- 流动资金贷款利率档次
    ,bilvvv  -- 利率
    ,decflg  -- 减额标志
    ,rskrat  -- 风险额度占用率
    ,cshpct  -- 保证金应收比例
    ,guaflg  -- 货押业务标志
    ,fincod  -- 借据号
    ,fintyp  -- 业务品种
    ,relcshpct  -- 保证金实收比例
    ,garfin  -- 融资/非融资保函标志
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.inr,chr(13),''),chr(10),'')  -- 保函内部ID号
    ,replace(replace(t1.ownref,chr(13),''),chr(10),'')  -- 参考号
    ,replace(replace(t1.nam,chr(13),''),chr(10),'')  -- 交易名称
    ,replace(replace(t1.ownusr,chr(13),''),chr(10),'')  -- 负责人
    ,t1.credat  -- 创建日期
    ,t1.opndat  -- 保函生效日，定义保函有效的开始日期
    ,t1.clsdat  -- 结束日期
    ,replace(replace(t1.oldref,chr(13),''),chr(10),'')  -- 以前的业务号
    ,t1.amedat  -- 最后一次修改日期
    ,t1.orddat  -- 客户订单日期
    ,t1.amenbr  -- 修改次数
    ,t1.pndclm  -- 为决的索偿次数
    ,replace(replace(t1.chato,chr(13),''),chr(10),'')  -- 费用流向，保函开立GITOPN交易中业务人员手工选择                                                                          1. On applicant side      赋值U                                                                                                                 2.On beneficariy side   赋值B                                                                                                      3.Other  赋值O
    ,t1.expdat  -- 保函的到期日，定义保函的期满日期
    ,t1.liadat  -- liability定义负载的有效期
    ,replace(replace(t1.stacty,chr(13),''),chr(10),'')  -- Country Code
    ,replace(replace(t1.ver,chr(13),''),chr(10),'')  -- 版本号
    ,replace(replace(t1.hndtyp,chr(13),''),chr(10),'')  -- 保函开立类型
    ,replace(replace(t1.gidtxtmodflg,chr(13),''),chr(10),'')  -- 修改交易文本
    ,replace(replace(t1.gtxinr,chr(13),''),chr(10),'')  -- 产生文本INR
    ,replace(replace(t1.giduil,chr(13),''),chr(10),'')  -- 语言
    ,replace(replace(t1.expflg,chr(13),''),chr(10),'')  -- 效期标志
    ,replace(replace(t1.liaflg,chr(13),''),chr(10),'')  -- 选择赋值X,不选赋值空
    ,t1.orcdat  -- 初始交易日期, 显示初始保函的日期
    ,replace(replace(t1.orcref,chr(13),''),chr(10),'')  -- 合同号
    ,replace(replace(t1.orccur,chr(13),''),chr(10),'')  -- 初始交易币种
    ,t1.orcamt  -- 初始交易金额
    ,t1.orcrat  -- 初始交易汇率
    ,replace(replace(t1.sndto,chr(13),''),chr(10),'')  -- 保函发给
    ,replace(replace(t1.purcan,chr(13),''),chr(10),'')  -- 取消原因
    ,replace(replace(t1.tenref,chr(13),''),chr(10),'')  -- 
    ,t1.tendat  -- 
    ,t1.avidat  -- 
    ,t1.tenclsdat  -- 
    ,replace(replace(t1.decrea,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.jurplc,chr(13),''),chr(10),'')  -- 权限位置
    ,replace(replace(t1.jurlaw,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.acc,chr(13),''),chr(10),'')  -- 预付款帐号
    ,replace(replace(t1.resflg,chr(13),''),chr(10),'')  -- 预留标志
    ,replace(replace(t1.stagod,chr(13),''),chr(10),'')  -- 货物代号
    ,t1.redamt  -- 减额
    ,replace(replace(t1.redcur,chr(13),''),chr(10),'')  -- 减额币种
    ,t1.reddat  -- 减额日期
    ,replace(replace(t1.outcur,chr(13),''),chr(10),'')  -- 余额币种
    ,t1.outamt  -- 余额
    ,replace(replace(t1.cnfsta,chr(13),''),chr(10),'')  -- 承兑状态
    ,t1.partcon  -- 部分承兑
    ,t1.cnfdat  -- 开立日期
    ,replace(replace(t1.cnfflg,chr(13),''),chr(10),'')  -- 按百分比还是金额承兑的标志
    ,replace(replace(t1.revflg,chr(13),''),chr(10),'')  -- 声明索偿标志位
    ,replace(replace(t1.etyextkey,chr(13),''),chr(10),'')  -- 实体交易
    ,replace(replace(t1.gartyp,chr(13),''),chr(10),'')  -- 保函类型
    ,t1.trmdat  -- 上次发送日
    ,replace(replace(t1.legfrm,chr(13),''),chr(10),'')  -- 所遵循的国际惯例
    ,t1.inudat  -- 生效日
    ,t1.feecoldat  -- 收费日期
    ,replace(replace(t1.bchkeyinr,chr(13),''),chr(10),'')  -- 经办机构号
    ,replace(replace(t1.branchinr,chr(13),''),chr(10),'')  -- 所属机构号
    ,replace(replace(t1.teskeyunc,chr(13),''),chr(10),'')  -- 测试标志
    ,replace(replace(t1.juscod,chr(13),''),chr(10),'')  -- 组织机构
    ,replace(replace(t1.cunqii,chr(13),''),chr(10),'')  -- 流动资金贷款利率档次
    ,t1.bilvvv  -- 利率
    ,replace(replace(t1.decflg,chr(13),''),chr(10),'')  -- 减额标志
    ,t1.rskrat  -- 风险额度占用率
    ,t1.cshpct  -- 保证金应收比例
    ,replace(replace(t1.guaflg,chr(13),''),chr(10),'')  -- 货押业务标志
    ,replace(replace(t1.fincod,chr(13),''),chr(10),'')  -- 借据号
    ,replace(replace(t1.fintyp,chr(13),''),chr(10),'')  -- 业务品种
    ,t1.relcshpct  -- 保证金实收比例
    ,replace(replace(t1.garfin,chr(13),''),chr(10),'')  -- 融资/非融资保函标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.isbs_gid t1    --保函业务信息(存放短字节)
where t1.start_dt <=to_date('${batch_date}','yyyymmdd') and t1.end_dt >to_date('${batch_date}','yyyymmdd') and t1.id_mark <> 'D' ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'aml_isbs_gid',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);