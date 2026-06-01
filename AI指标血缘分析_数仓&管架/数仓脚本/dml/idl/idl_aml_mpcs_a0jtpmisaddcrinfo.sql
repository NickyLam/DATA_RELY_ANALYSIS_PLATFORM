/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_aml_mpcs_a0jtpmisaddcrinfo
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
alter table ${idl_schema}.aml_mpcs_a0jtpmisaddcrinfo drop partition p_${last_date};
alter table ${idl_schema}.aml_mpcs_a0jtpmisaddcrinfo drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.aml_mpcs_a0jtpmisaddcrinfo add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.aml_mpcs_a0jtpmisaddcrinfo partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,mainseq  -- 中台流水号
    ,transdt  -- 交易日期
    ,status  -- 交易状态 Z 初始状态 1 已应答
    ,trantype  -- 交易类型
    ,bank_self_num  -- 银行自身流水号
    ,biz_type_code  -- 业务类型代码
    ,idtype_code  -- 证件类型代码
    ,idcode  -- 证件号码
    ,ctycode  -- 国家/地区代码
    ,add_idcode  -- 补充证件号码
    ,person_name  -- 姓名
    ,biz_tx_chnl_code  -- 务办理渠道代码
    ,txccy  -- 币种
    ,cr_amt  -- 存钞金额
    ,acct_no  -- 个人外汇账户账号
    ,remark  -- 备注
    ,refno  -- 业务参号
    ,code  -- 代码
    ,detail  -- 错误详细信息
    ,cr_amt_date  -- 当日已存入金额（折美元）
    ,cr_amt_year  -- 当年已存入金额（折美元）
    ,src  -- 发起节点代码
    ,des  -- 接收节点代码
    ,sendtime  -- 发送时间
    ,common_org_code  -- 机构代码
    ,msgno  -- 报文参考号
    ,transmessage  -- 交易信息
    ,edit_reason_code  -- 修改/撤销原因代码
    ,edit_remark  -- 修改/撤销原因说明
    ,brcno  -- 机构号
    ,tlrno  -- 柜员
    ,srcseqno  -- 柜面交易流水
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.mainseq,chr(13),''),chr(10),'')  -- 中台流水号
    ,replace(replace(t1.transdt,chr(13),''),chr(10),'')  -- 交易日期
    ,replace(replace(t1.status,chr(13),''),chr(10),'')  -- 交易状态 Z 初始状态 1 已应答
    ,replace(replace(t1.trantype,chr(13),''),chr(10),'')  -- 交易类型
    ,replace(replace(t1.bank_self_num,chr(13),''),chr(10),'')  -- 银行自身流水号
    ,replace(replace(t1.biz_type_code,chr(13),''),chr(10),'')  -- 业务类型代码
    ,replace(replace(t1.idtype_code,chr(13),''),chr(10),'')  -- 证件类型代码
    ,replace(replace(t1.idcode,chr(13),''),chr(10),'')  -- 证件号码
    ,replace(replace(t1.ctycode,chr(13),''),chr(10),'')  -- 国家/地区代码
    ,replace(replace(t1.add_idcode,chr(13),''),chr(10),'')  -- 补充证件号码
    ,replace(replace(t1.person_name,chr(13),''),chr(10),'')  -- 姓名
    ,replace(replace(t1.biz_tx_chnl_code,chr(13),''),chr(10),'')  -- 务办理渠道代码
    ,replace(replace(t1.txccy,chr(13),''),chr(10),'')  -- 币种
    ,replace(replace(t1.cr_amt,chr(13),''),chr(10),'')  -- 存钞金额
    ,replace(replace(t1.acct_no,chr(13),''),chr(10),'')  -- 个人外汇账户账号
    ,replace(replace(t1.remark,chr(13),''),chr(10),'')  -- 备注
    ,replace(replace(t1.refno,chr(13),''),chr(10),'')  -- 业务参号
    ,replace(replace(t1.code,chr(13),''),chr(10),'')  -- 代码
    ,replace(replace(t1.detail,chr(13),''),chr(10),'')  -- 错误详细信息
    ,replace(replace(t1.cr_amt_date,chr(13),''),chr(10),'')  -- 当日已存入金额（折美元）
    ,replace(replace(t1.cr_amt_year,chr(13),''),chr(10),'')  -- 当年已存入金额（折美元）
    ,replace(replace(t1.src,chr(13),''),chr(10),'')  -- 发起节点代码
    ,replace(replace(t1.des,chr(13),''),chr(10),'')  -- 接收节点代码
    ,replace(replace(t1.sendtime,chr(13),''),chr(10),'')  -- 发送时间
    ,replace(replace(t1.common_org_code,chr(13),''),chr(10),'')  -- 机构代码
    ,replace(replace(t1.msgno,chr(13),''),chr(10),'')  -- 报文参考号
    ,replace(replace(t1.transmessage,chr(13),''),chr(10),'')  -- 交易信息
    ,replace(replace(t1.edit_reason_code,chr(13),''),chr(10),'')  -- 修改/撤销原因代码
    ,replace(replace(t1.edit_remark,chr(13),''),chr(10),'')  -- 修改/撤销原因说明
    ,replace(replace(t1.brcno,chr(13),''),chr(10),'')  -- 机构号
    ,replace(replace(t1.tlrno,chr(13),''),chr(10),'')  -- 柜员
    ,replace(replace(t1.srcseqno,chr(13),''),chr(10),'')  -- 柜面交易流水
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.mpcs_a0jtpmisaddcrinfo t1    --外币存入信息表
where t1.start_dt <=to_date('${batch_date}','yyyymmdd') and t1.end_dt >to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'aml_mpcs_a0jtpmisaddcrinfo',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);