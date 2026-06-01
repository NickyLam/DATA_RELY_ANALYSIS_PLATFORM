/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_aml_mpcs_a0jtpmisqryfxsatqquota
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
alter table ${idl_schema}.aml_mpcs_a0jtpmisqryfxsatqquota drop partition p_${last_date};
alter table ${idl_schema}.aml_mpcs_a0jtpmisqryfxsatqquota drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.aml_mpcs_a0jtpmisqryfxsatqquota add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.aml_mpcs_a0jtpmisqryfxsatqquota partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,mainseq  -- 中台流水号
    ,transdt  -- 交易日期
    ,status  -- 交易状态 Z 初始状态 0-发送失败 1 发送成功
    ,trantype  -- 交易类型 JH结汇 GH购汇
    ,idtype_code  -- 证件类型
    ,idcode  -- 证件号码
    ,ctycode  -- 国家/地区代码
    ,ann_lcyamt_usd  -- 本年额度内已结汇金额折美元
    ,ann_rem_lcyamt_usd  -- 本年额度内剩余可结汇金额折美元
    ,cr_amt_usd_sumday  -- 当日已存入金额折美元
    ,cr_amt_usd_sumyear  -- 当年已存入金额折美元
    ,ann_fcyamt_usd  -- 本年额度内已购汇金额折美元
    ,ann_rem_fcyamt_usd  -- 本年额度内剩余可购汇金额折美元
    ,zq_amt_usd_date  -- 当日已提取金额（折美元）
    ,zq_amt_usd_year  -- 当年已提取金额（折美元）
    ,custname  -- 交易主体姓名
    ,custtype_code  -- 交易主体类型代码
    ,type_status  -- 个人主体分类状态代码
    ,pub_date  -- 发布日期
    ,end_date  -- 到期日期
    ,pub_reason  -- 发布原因
    ,pub_code  -- 发布原因代码 01分拆收结汇境外汇款人02分拆收结汇参与者03分拆收结汇资金归集者04分拆购付汇资金提供者05-分拆购付汇参与者06分拆购付汇境外收款人07多次协助他人规避额度及真实性管理99其他
    ,pub_org  -- 关注名单发布机构
    ,sign_status  -- 风险提示函/告知书告知状态 0未告知1已告知
    ,is_check  -- 是否是待核查处理个人  Y 是/ N 否
    ,is_notice  -- 待核查处理个人是否已告知 Y 是/ N 否
    ,check_pub_date  -- 待核查处理个人发布日期
    ,check_end_date  -- 待核查处理个人到期日期
    ,check_pub_reason  -- 待核查处理个人发布原因
    ,check_pub_code  -- 待核查处理个人发布原因代码 01可疑现钞业务 02可疑结售汇业务 03可疑收支业务 04虚假申报信息 05其他业务
    ,check_pub_branch  -- 待核查处理个人发布机构
    ,magebrn  -- 机构号
    ,oprtlr  -- 柜员号
    ,fronttrcd  -- 中台交易码
    ,servicepath  -- 访问服务信息
    ,remark  -- 备注
    ,src  -- 发起节点代码
    ,des  -- 接收节点代码
    ,sendtime  -- 发送时间
    ,common_org_code  -- 机构代码
    ,msgno  -- 报文参考号
    ,zyed_flag  -- 占用额度标识 0是占用额度,1非占用额度
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.mainseq,chr(13),''),chr(10),'')  -- 中台流水号
    ,replace(replace(t1.transdt,chr(13),''),chr(10),'')  -- 交易日期
    ,replace(replace(t1.status,chr(13),''),chr(10),'')  -- 交易状态 Z 初始状态 0-发送失败 1 发送成功
    ,replace(replace(t1.trantype,chr(13),''),chr(10),'')  -- 交易类型 JH结汇 GH购汇
    ,replace(replace(t1.idtype_code,chr(13),''),chr(10),'')  -- 证件类型
    ,replace(replace(t1.idcode,chr(13),''),chr(10),'')  -- 证件号码
    ,replace(replace(t1.ctycode,chr(13),''),chr(10),'')  -- 国家/地区代码
    ,replace(replace(t1.ann_lcyamt_usd,chr(13),''),chr(10),'')  -- 本年额度内已结汇金额折美元
    ,replace(replace(t1.ann_rem_lcyamt_usd,chr(13),''),chr(10),'')  -- 本年额度内剩余可结汇金额折美元
    ,replace(replace(t1.cr_amt_usd_sumday,chr(13),''),chr(10),'')  -- 当日已存入金额折美元
    ,replace(replace(t1.cr_amt_usd_sumyear,chr(13),''),chr(10),'')  -- 当年已存入金额折美元
    ,replace(replace(t1.ann_fcyamt_usd,chr(13),''),chr(10),'')  -- 本年额度内已购汇金额折美元
    ,replace(replace(t1.ann_rem_fcyamt_usd,chr(13),''),chr(10),'')  -- 本年额度内剩余可购汇金额折美元
    ,replace(replace(t1.zq_amt_usd_date,chr(13),''),chr(10),'')  -- 当日已提取金额（折美元）
    ,replace(replace(t1.zq_amt_usd_year,chr(13),''),chr(10),'')  -- 当年已提取金额（折美元）
    ,replace(replace(t1.custname,chr(13),''),chr(10),'')  -- 交易主体姓名
    ,replace(replace(t1.custtype_code,chr(13),''),chr(10),'')  -- 交易主体类型代码
    ,replace(replace(t1.type_status,chr(13),''),chr(10),'')  -- 个人主体分类状态代码
    ,replace(replace(t1.pub_date,chr(13),''),chr(10),'')  -- 发布日期
    ,replace(replace(t1.end_date,chr(13),''),chr(10),'')  -- 到期日期
    ,replace(replace(t1.pub_reason,chr(13),''),chr(10),'')  -- 发布原因
    ,replace(replace(t1.pub_code,chr(13),''),chr(10),'')  -- 发布原因代码 01分拆收结汇境外汇款人02分拆收结汇参与者03分拆收结汇资金归集者04分拆购付汇资金提供者05-分拆购付汇参与者06分拆购付汇境外收款人07多次协助他人规避额度及真实性管理99其他
    ,replace(replace(t1.pub_org,chr(13),''),chr(10),'')  -- 关注名单发布机构
    ,replace(replace(t1.sign_status,chr(13),''),chr(10),'')  -- 风险提示函/告知书告知状态 0未告知1已告知
    ,replace(replace(t1.is_check,chr(13),''),chr(10),'')  -- 是否是待核查处理个人  Y 是/ N 否
    ,replace(replace(t1.is_notice,chr(13),''),chr(10),'')  -- 待核查处理个人是否已告知 Y 是/ N 否
    ,replace(replace(t1.check_pub_date,chr(13),''),chr(10),'')  -- 待核查处理个人发布日期
    ,replace(replace(t1.check_end_date,chr(13),''),chr(10),'')  -- 待核查处理个人到期日期
    ,replace(replace(t1.check_pub_reason,chr(13),''),chr(10),'')  -- 待核查处理个人发布原因
    ,replace(replace(t1.check_pub_code,chr(13),''),chr(10),'')  -- 待核查处理个人发布原因代码 01可疑现钞业务 02可疑结售汇业务 03可疑收支业务 04虚假申报信息 05其他业务
    ,replace(replace(t1.check_pub_branch,chr(13),''),chr(10),'')  -- 待核查处理个人发布机构
    ,replace(replace(t1.magebrn,chr(13),''),chr(10),'')  -- 机构号
    ,replace(replace(t1.oprtlr,chr(13),''),chr(10),'')  -- 柜员号
    ,replace(replace(t1.fronttrcd,chr(13),''),chr(10),'')  -- 中台交易码
    ,replace(replace(t1.servicepath,chr(13),''),chr(10),'')  -- 访问服务信息
    ,replace(replace(t1.remark,chr(13),''),chr(10),'')  -- 备注
    ,replace(replace(t1.src,chr(13),''),chr(10),'')  -- 发起节点代码
    ,replace(replace(t1.des,chr(13),''),chr(10),'')  -- 接收节点代码
    ,replace(replace(t1.sendtime,chr(13),''),chr(10),'')  -- 发送时间
    ,replace(replace(t1.common_org_code,chr(13),''),chr(10),'')  -- 机构代码
    ,replace(replace(t1.msgno,chr(13),''),chr(10),'')  -- 报文参考号
    ,replace(replace(t1.zyed_flag,chr(13),''),chr(10),'')  -- 占用额度标识 0是占用额度,1非占用额度
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota t1    --结售汇额度信息查询表
where t1.start_dt <=to_date('${batch_date}','yyyymmdd') and t1.end_dt >to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'aml_mpcs_a0jtpmisqryfxsatqquota',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);