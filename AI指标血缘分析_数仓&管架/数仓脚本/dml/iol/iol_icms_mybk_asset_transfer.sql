/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_mybk_asset_transfer
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_mybk_asset_transfer_ex purge;
alter table ${iol_schema}.icms_mybk_asset_transfer add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.icms_mybk_asset_transfer truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.icms_mybk_asset_transfer_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_mybk_asset_transfer where 0=1;

insert /*+ append */ into ${iol_schema}.icms_mybk_asset_transfer_ex(
    serialno -- 流水号
    ,riskrank -- 风险等级
    ,bal -- 贷款余额(元)
    ,guaranteeitem -- 担保品
    ,ischeckinspect -- 联网核查是否通过
    ,province -- 地区省份
    ,statusdesc -- 经营状态
    ,migtflag -- 迁移标志：crsrcrilcupl
    ,userage -- 年龄
    ,reminddays -- 贷款剩余期限（天）
    ,registerfund -- 注册资本
    ,inputid -- 客户经理
    ,intrate -- 贷款利率（%）
    ,currentstatus -- 当前状态
    ,inttype -- 利率浮动方式
    ,creditbal -- 单户授信（元）
    ,butpye -- 企业类型
    ,registeraddress -- 注册地址
    ,firstloanlengthgrade -- 信贷时长等级
    ,assetclass -- 贷款五级分类
    ,manageenddate -- 经营结束时间
    ,repaymodedesc -- 贷款付息方式(个月/次)
    ,isgetcuscode -- 是否开户成功
    ,injectid -- 转让批次号
    ,drawndnseqno -- 支用编号
    ,companytype -- 公司类型
    ,failreason -- 拒绝原因
    ,mobileno -- 借款人手机号码
    ,loanusetype -- 贷款用途
    ,duedate -- 贷款到期日
    ,lastcheckyear -- 最后年检年度
    ,managebegindate -- 经营开始时间
    ,ovdorderamt6mgrade -- 最近六个月逾期金额等级
    ,registerdate -- 注册时间
    ,registerdepartment -- 注册工商局
    ,certtype -- 借款人证件类型
    ,ovdordercnt6mgrade -- 最近六个月逾期笔数等级
    ,positivebizcnt1ygrade -- 最近一年履约等级
    ,registerno -- 工商注册号
    ,inputdate -- 下载日期
    ,termnum -- 贷款期限（月）
    ,entityname -- 公司名
    ,name -- 借款人名称
    ,certno -- 借款人证件号
    ,loantype -- 贷款类型
    ,registeraddressareacode -- 注册地行政区编号
    ,registeraddressarea -- 注册地省市区
    ,approvestatus -- 审批状态
    ,useraddress -- 借款人住址
    ,guaranteemethod -- 担保方式
    ,lawer -- 法定代表人
    ,apprendtime -- 审批结束时间
    ,currencytype -- 币种
    ,amt -- 合同金额(元)
    ,disbursedate -- 贷款起息日
    ,managerange -- 经营范围
    ,cusid -- 客户号
    ,repaymentseg -- 偿债能力
    ,ovdorderdays6mgrade -- 最近六个月逾期天数等级
    ,riskscore -- 风险分数
    ,ovdlog6m -- 六个月逾期记录
    ,tradecode -- 行业代码
    ,opendate -- 开业时间
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    serialno -- 流水号
    ,riskrank -- 风险等级
    ,bal -- 贷款余额(元)
    ,guaranteeitem -- 担保品
    ,ischeckinspect -- 联网核查是否通过
    ,province -- 地区省份
    ,statusdesc -- 经营状态
    ,migtflag -- 迁移标志：crsrcrilcupl
    ,userage -- 年龄
    ,reminddays -- 贷款剩余期限（天）
    ,registerfund -- 注册资本
    ,inputid -- 客户经理
    ,intrate -- 贷款利率（%）
    ,currentstatus -- 当前状态
    ,inttype -- 利率浮动方式
    ,creditbal -- 单户授信（元）
    ,butpye -- 企业类型
    ,registeraddress -- 注册地址
    ,firstloanlengthgrade -- 信贷时长等级
    ,assetclass -- 贷款五级分类
    ,manageenddate -- 经营结束时间
    ,repaymodedesc -- 贷款付息方式(个月/次)
    ,isgetcuscode -- 是否开户成功
    ,injectid -- 转让批次号
    ,drawndnseqno -- 支用编号
    ,companytype -- 公司类型
    ,failreason -- 拒绝原因
    ,mobileno -- 借款人手机号码
    ,loanusetype -- 贷款用途
    ,duedate -- 贷款到期日
    ,lastcheckyear -- 最后年检年度
    ,managebegindate -- 经营开始时间
    ,ovdorderamt6mgrade -- 最近六个月逾期金额等级
    ,registerdate -- 注册时间
    ,registerdepartment -- 注册工商局
    ,certtype -- 借款人证件类型
    ,ovdordercnt6mgrade -- 最近六个月逾期笔数等级
    ,positivebizcnt1ygrade -- 最近一年履约等级
    ,registerno -- 工商注册号
    ,inputdate -- 下载日期
    ,termnum -- 贷款期限（月）
    ,entityname -- 公司名
    ,name -- 借款人名称
    ,certno -- 借款人证件号
    ,loantype -- 贷款类型
    ,registeraddressareacode -- 注册地行政区编号
    ,registeraddressarea -- 注册地省市区
    ,approvestatus -- 审批状态
    ,useraddress -- 借款人住址
    ,guaranteemethod -- 担保方式
    ,lawer -- 法定代表人
    ,apprendtime -- 审批结束时间
    ,currencytype -- 币种
    ,amt -- 合同金额(元)
    ,disbursedate -- 贷款起息日
    ,managerange -- 经营范围
    ,cusid -- 客户号
    ,repaymentseg -- 偿债能力
    ,ovdorderdays6mgrade -- 最近六个月逾期天数等级
    ,riskscore -- 风险分数
    ,ovdlog6m -- 六个月逾期记录
    ,tradecode -- 行业代码
    ,opendate -- 开业时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.icms_mybk_asset_transfer
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.icms_mybk_asset_transfer exchange partition p_${batch_date} with table ${iol_schema}.icms_mybk_asset_transfer_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_mybk_asset_transfer to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.icms_mybk_asset_transfer_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_mybk_asset_transfer',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);