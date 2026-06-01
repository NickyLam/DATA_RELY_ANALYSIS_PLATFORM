/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_aml_mpcs_a0jtpmisaddtqinfo
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
alter table ${idl_schema}.aml_mpcs_a0jtpmisaddtqinfo drop partition p_${last_date};
alter table ${idl_schema}.aml_mpcs_a0jtpmisaddtqinfo drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.aml_mpcs_a0jtpmisaddtqinfo add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.aml_mpcs_a0jtpmisaddtqinfo partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,mainseq  -- 中台流水号
    ,transdt  -- 交易日期
    ,trantype  -- 交易类型 1-提钞 2-提钞补录
    ,biz_type_code  -- 业务类型 02-账户提钞/06-外币兑换外币提取/08-其他提钞
    ,bank_self_num  -- 银行自身流水号
    ,idtype_code  -- 证件类型代码
    ,idcode  -- 证件号码
    ,person_name  -- 姓名
    ,ctycode  -- 国家/地区代码
    ,add_idcode  -- 补充证件号码
    ,biz_tx_chnl_code  -- 业务办理渠道代码 12-柜台渠道（接口模式） 23-自助终端 42-特许兑换机构（接口模式柜台业务） 52-非银行金融机构（接口模式柜台业务）
    ,txccy  -- 币种
    ,zq_amt  -- 金额
    ,acct_no  -- 个人外汇账户账号
    ,biz_tx_time  -- 业务办理时间
    ,remark  -- 备注
    ,rein_reason_code  -- 补录原因代码
    ,rein_remark  -- 补录说明
    ,status  -- 交易状态 Z 初始状态 0-失败 1-成功 C-已撤销
    ,refno  -- 业务参号
    ,code  -- 返回码
    ,detail  -- 返回信息
    ,tq_amt_date  -- 当日已提取金额（折美元）
    ,tq_amt_year  -- 当年已提取金额（折美元）
    ,src  -- 发起节点代码
    ,des  -- 接收节点代码
    ,sendtime  -- 发送时间
    ,common_org_code  -- 机构代码
    ,msgno  -- 报文参考号
    ,brcno  -- 交易机构
    ,tlrno  -- 交易柜员
    ,srcsysid  -- 渠道
    ,srcseqno  -- 渠道流水号
    ,uptm  -- 更新时间
    ,upbrcno  -- 更新机构
    ,uptlrno  -- 更新柜员
    ,uptype  -- 更新类型 0-查询 1-修改 2-撤销
    ,upreason_code  -- 更新原因代码
    ,upremark  -- 更新原因
    ,uprefno  -- 更新业务参考号
    ,upbank_self_num  -- 更新银行自身流水号
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.mainseq,chr(13),''),chr(10),'')  -- 中台流水号
    ,replace(replace(t1.transdt,chr(13),''),chr(10),'')  -- 交易日期
    ,replace(replace(t1.trantype,chr(13),''),chr(10),'')  -- 交易类型 1-提钞 2-提钞补录
    ,replace(replace(t1.biz_type_code,chr(13),''),chr(10),'')  -- 业务类型 02-账户提钞/06-外币兑换外币提取/08-其他提钞
    ,replace(replace(t1.bank_self_num,chr(13),''),chr(10),'')  -- 银行自身流水号
    ,replace(replace(t1.idtype_code,chr(13),''),chr(10),'')  -- 证件类型代码
    ,replace(replace(t1.idcode,chr(13),''),chr(10),'')  -- 证件号码
    ,replace(replace(t1.person_name,chr(13),''),chr(10),'')  -- 姓名
    ,replace(replace(t1.ctycode,chr(13),''),chr(10),'')  -- 国家/地区代码
    ,replace(replace(t1.add_idcode,chr(13),''),chr(10),'')  -- 补充证件号码
    ,replace(replace(t1.biz_tx_chnl_code,chr(13),''),chr(10),'')  -- 业务办理渠道代码 12-柜台渠道（接口模式） 23-自助终端 42-特许兑换机构（接口模式柜台业务） 52-非银行金融机构（接口模式柜台业务）
    ,replace(replace(t1.txccy,chr(13),''),chr(10),'')  -- 币种
    ,replace(replace(t1.zq_amt,chr(13),''),chr(10),'')  -- 金额
    ,replace(replace(t1.acct_no,chr(13),''),chr(10),'')  -- 个人外汇账户账号
    ,replace(replace(t1.biz_tx_time,chr(13),''),chr(10),'')  -- 业务办理时间
    ,replace(replace(t1.remark,chr(13),''),chr(10),'')  -- 备注
    ,replace(replace(t1.rein_reason_code,chr(13),''),chr(10),'')  -- 补录原因代码
    ,replace(replace(t1.rein_remark,chr(13),''),chr(10),'')  -- 补录说明
    ,replace(replace(t1.status,chr(13),''),chr(10),'')  -- 交易状态 Z 初始状态 0-失败 1-成功 C-已撤销
    ,replace(replace(t1.refno,chr(13),''),chr(10),'')  -- 业务参号
    ,replace(replace(t1.code,chr(13),''),chr(10),'')  -- 返回码
    ,replace(replace(t1.detail,chr(13),''),chr(10),'')  -- 返回信息
    ,replace(replace(t1.tq_amt_date,chr(13),''),chr(10),'')  -- 当日已提取金额（折美元）
    ,replace(replace(t1.tq_amt_year,chr(13),''),chr(10),'')  -- 当年已提取金额（折美元）
    ,replace(replace(t1.src,chr(13),''),chr(10),'')  -- 发起节点代码
    ,replace(replace(t1.des,chr(13),''),chr(10),'')  -- 接收节点代码
    ,replace(replace(t1.sendtime,chr(13),''),chr(10),'')  -- 发送时间
    ,replace(replace(t1.common_org_code,chr(13),''),chr(10),'')  -- 机构代码
    ,replace(replace(t1.msgno,chr(13),''),chr(10),'')  -- 报文参考号
    ,replace(replace(t1.brcno,chr(13),''),chr(10),'')  -- 交易机构
    ,replace(replace(t1.tlrno,chr(13),''),chr(10),'')  -- 交易柜员
    ,replace(replace(t1.srcsysid,chr(13),''),chr(10),'')  -- 渠道
    ,replace(replace(t1.srcseqno,chr(13),''),chr(10),'')  -- 渠道流水号
    ,replace(replace(t1.uptm,chr(13),''),chr(10),'')  -- 更新时间
    ,replace(replace(t1.upbrcno,chr(13),''),chr(10),'')  -- 更新机构
    ,replace(replace(t1.uptlrno,chr(13),''),chr(10),'')  -- 更新柜员
    ,replace(replace(t1.uptype,chr(13),''),chr(10),'')  -- 更新类型 0-查询 1-修改 2-撤销
    ,replace(replace(t1.upreason_code,chr(13),''),chr(10),'')  -- 更新原因代码
    ,replace(replace(t1.upremark,chr(13),''),chr(10),'')  -- 更新原因
    ,replace(replace(t1.uprefno,chr(13),''),chr(10),'')  -- 更新业务参考号
    ,replace(replace(t1.upbank_self_num,chr(13),''),chr(10),'')  -- 更新银行自身流水号
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.mpcs_a0jtpmisaddtqinfo t1    --外币提取信息表
where t1.start_dt <=to_date('${batch_date}','yyyymmdd') and t1.end_dt >to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'aml_mpcs_a0jtpmisaddtqinfo',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);