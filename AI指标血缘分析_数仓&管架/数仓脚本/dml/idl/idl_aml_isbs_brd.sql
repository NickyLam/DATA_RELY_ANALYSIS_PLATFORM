/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_aml_isbs_brd
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
alter table ${idl_schema}.aml_isbs_brd drop partition p_${last_date};
alter table ${idl_schema}.aml_isbs_brd drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.aml_isbs_brd add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.aml_isbs_brd partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,inr  -- 进口单据INR号
    ,ownref  -- 来单参考号
    ,nam  -- 来单名称
    ,ownusr  -- 负责人
    ,credat  -- 寄单日期
    ,opndat  -- 开证日期
    ,clsdat  -- 结束日期
    ,pnttyp  -- 父类类型
    ,pntinr  -- 父类交易INR号
    ,predat  -- 寄单行寄单日期
    ,shpdat  -- 最迟装运日期
    ,spddat  -- 过期日期
    ,totdat  -- 总天数
    ,advdat  -- 通知日期
    ,matdat  -- 效期
    ,rcvdat  -- 提单收到日期
    ,disdat  -- 不符点通知日期
    ,docflg  -- 到单标志
    ,rejflg  -- 拒付标志
    ,approvcod  -- 是否批准
    ,relgodflg  -- 货物授权标志
    ,relgoddat  -- 授权日期
    ,trpdocnum  -- 传送单据数目
    ,frepayflg  -- 免付款交单标志
    ,ver  -- 版本号
    ,advtyp  -- 接收的的通知类型
    ,reltyp  -- 授权类型
    ,expdat  -- 提货担保开立日期
    ,rtoaplflg  -- 货物授权申请人标志
    ,trpdoctyp  -- 提单类型
    ,tradat  -- 提单日期
    ,tramod  -- 运输类型
    ,mattxtflg  -- 多期限标志
    ,dscinsflg  -- 单据差异标志
    ,docprbrol  -- 提交角色
    ,docsta  -- 单据类型
    ,igndisflg  -- 忽略不符点标志
    ,totcur  -- 付款总金额币种
    ,totamt  -- 付款总金额
    ,payrol  -- 付款人
    ,acpnowflg  -- 承兑标志
    ,orddat  -- 来单日期
    ,advdocflg  -- 退单标志
    ,etyextkey  -- 实体组
    ,bchkeyinr  -- 经办机构号
    ,branchinr  -- 所属机构号
    ,ngrcod  -- 货物代码
    ,sgdinr  -- 提货担保inr
    ,blnum  -- 提单号
    ,shgref  -- 提货担保参考号
    ,fincod  -- 借据号
    ,fintyp  -- 业务品种
    ,nraflg  -- NRA付款标志
    ,qsqdbh  -- 清算渠道
    ,invnum  -- 
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.inr,chr(13),''),chr(10),'')  -- 进口单据INR号
    ,replace(replace(t1.ownref,chr(13),''),chr(10),'')  -- 来单参考号
    ,replace(replace(t1.nam,chr(13),''),chr(10),'')  -- 来单名称
    ,replace(replace(t1.ownusr,chr(13),''),chr(10),'')  -- 负责人
    ,t1.credat  -- 寄单日期
    ,t1.opndat  -- 开证日期
    ,t1.clsdat  -- 结束日期
    ,replace(replace(t1.pnttyp,chr(13),''),chr(10),'')  -- 父类类型
    ,replace(replace(t1.pntinr,chr(13),''),chr(10),'')  -- 父类交易INR号
    ,t1.predat  -- 寄单行寄单日期
    ,t1.shpdat  -- 最迟装运日期
    ,t1.spddat  -- 过期日期
    ,t1.totdat  -- 总天数
    ,t1.advdat  -- 通知日期
    ,t1.matdat  -- 效期
    ,t1.rcvdat  -- 提单收到日期
    ,t1.disdat  -- 不符点通知日期
    ,replace(replace(t1.docflg,chr(13),''),chr(10),'')  -- 到单标志
    ,replace(replace(t1.rejflg,chr(13),''),chr(10),'')  -- 拒付标志
    ,replace(replace(t1.approvcod,chr(13),''),chr(10),'')  -- 是否批准
    ,replace(replace(t1.relgodflg,chr(13),''),chr(10),'')  -- 货物授权标志
    ,t1.relgoddat  -- 授权日期
    ,replace(replace(t1.trpdocnum,chr(13),''),chr(10),'')  -- 传送单据数目
    ,replace(replace(t1.frepayflg,chr(13),''),chr(10),'')  -- 免付款交单标志
    ,replace(replace(t1.ver,chr(13),''),chr(10),'')  -- 版本号
    ,replace(replace(t1.advtyp,chr(13),''),chr(10),'')  -- 接收的的通知类型
    ,replace(replace(t1.reltyp,chr(13),''),chr(10),'')  -- 授权类型
    ,t1.expdat  -- 提货担保开立日期
    ,replace(replace(t1.rtoaplflg,chr(13),''),chr(10),'')  -- 货物授权申请人标志
    ,replace(replace(t1.trpdoctyp,chr(13),''),chr(10),'')  -- 提单类型
    ,t1.tradat  -- 提单日期
    ,replace(replace(t1.tramod,chr(13),''),chr(10),'')  -- 运输类型
    ,replace(replace(t1.mattxtflg,chr(13),''),chr(10),'')  -- 多期限标志
    ,replace(replace(t1.dscinsflg,chr(13),''),chr(10),'')  -- 单据差异标志
    ,replace(replace(t1.docprbrol,chr(13),''),chr(10),'')  -- 提交角色
    ,replace(replace(t1.docsta,chr(13),''),chr(10),'')  -- 单据类型
    ,replace(replace(t1.igndisflg,chr(13),''),chr(10),'')  -- 忽略不符点标志
    ,replace(replace(t1.totcur,chr(13),''),chr(10),'')  -- 付款总金额币种
    ,t1.totamt  -- 付款总金额
    ,replace(replace(t1.payrol,chr(13),''),chr(10),'')  -- 付款人
    ,replace(replace(t1.acpnowflg,chr(13),''),chr(10),'')  -- 承兑标志
    ,t1.orddat  -- 来单日期
    ,replace(replace(t1.advdocflg,chr(13),''),chr(10),'')  -- 退单标志
    ,replace(replace(t1.etyextkey,chr(13),''),chr(10),'')  -- 实体组
    ,replace(replace(t1.bchkeyinr,chr(13),''),chr(10),'')  -- 经办机构号
    ,replace(replace(t1.branchinr,chr(13),''),chr(10),'')  -- 所属机构号
    ,replace(replace(t1.ngrcod,chr(13),''),chr(10),'')  -- 货物代码
    ,replace(replace(t1.sgdinr,chr(13),''),chr(10),'')  -- 提货担保inr
    ,replace(replace(t1.blnum,chr(13),''),chr(10),'')  -- 提单号
    ,replace(replace(t1.shgref,chr(13),''),chr(10),'')  -- 提货担保参考号
    ,replace(replace(t1.fincod,chr(13),''),chr(10),'')  -- 借据号
    ,replace(replace(t1.fintyp,chr(13),''),chr(10),'')  -- 业务品种
    ,replace(replace(t1.nraflg,chr(13),''),chr(10),'')  -- NRA付款标志
    ,replace(replace(t1.qsqdbh,chr(13),''),chr(10),'')  -- 清算渠道
    ,replace(replace(t1.invnum,chr(13),''),chr(10),'')  -- 
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.isbs_brd t1    --进口信用证下单据业务信息(存放短字节内容)
where t1.start_dt <=to_date('${batch_date}','yyyymmdd') and t1.end_dt >to_date('${batch_date}','yyyymmdd') and t1.id_mark <> 'D' ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'aml_isbs_brd',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);