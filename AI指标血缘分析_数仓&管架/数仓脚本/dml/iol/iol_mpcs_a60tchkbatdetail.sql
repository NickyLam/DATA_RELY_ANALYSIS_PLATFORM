/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a60tchkbatdetail
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
drop table ${iol_schema}.mpcs_a60tchkbatdetail_ex purge;
alter table ${iol_schema}.mpcs_a60tchkbatdetail add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.mpcs_a60tchkbatdetail truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.mpcs_a60tchkbatdetail_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a60tchkbatdetail where 0=1;

insert /*+ append */ into ${iol_schema}.mpcs_a60tchkbatdetail_ex(
    trannbr -- 交易流水号
    ,trandate -- 交易日期
    ,trantime -- 交易时间
    ,batdt -- 批次日期
    ,batno -- 批次号
    ,batseqno -- 批次序号
    ,trancode -- 交易码
    ,linkid -- 链路ID
    ,bnakcode -- 银行代码
    ,identype -- 证件类型
    ,idennbr -- 证件号码
    ,nationality -- 国家代码
    ,cltname -- 证件姓名
    ,issueoffice -- 签发机构
    ,photoname -- 相片文件名
    ,chkresult -- 验证结果
    ,status -- S：验证成功T：验证失败W：初始状态
    ,srcseqno -- 报文流水号
    ,srcsysid -- 系统ID
    ,tlrno -- 交易代码
    ,brcno -- 机构号
    ,checkchnl -- 核查通道0-人行1-国证通2-本地
    ,recordstat -- 记录状态0-无效1-有效
    ,checkdept -- 核查部门1-互联网银行事业部2-个人银行部3-公司银行部4-零售信贷部5-金融市场部6-授信审批部7-微贷产品事业部8-交易银行部9-同业银行部10-汕头分行银行部
    ,checktype -- 核查类型
    ,photo -- 照片流
    ,businesstype -- 业务种类
    ,trantype -- 交易类型
    ,chkrspmsg -- 核查结果信息
    ,transeqno -- 中台流水
    ,loadflg -- 导出标识：0-初始化；1-已导出；2-导出中
    ,dealflg -- 处理标识：0-未处理；1-已核查；2-核查中
    ,feecntflg -- 费用统计标识：0-未统计；1-已统计
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    trannbr -- 交易流水号
    ,trandate -- 交易日期
    ,trantime -- 交易时间
    ,batdt -- 批次日期
    ,batno -- 批次号
    ,batseqno -- 批次序号
    ,trancode -- 交易码
    ,linkid -- 链路ID
    ,bnakcode -- 银行代码
    ,identype -- 证件类型
    ,idennbr -- 证件号码
    ,nationality -- 国家代码
    ,cltname -- 证件姓名
    ,issueoffice -- 签发机构
    ,photoname -- 相片文件名
    ,chkresult -- 验证结果
    ,status -- S：验证成功T：验证失败W：初始状态
    ,srcseqno -- 报文流水号
    ,srcsysid -- 系统ID
    ,tlrno -- 交易代码
    ,brcno -- 机构号
    ,checkchnl -- 核查通道0-人行1-国证通2-本地
    ,recordstat -- 记录状态0-无效1-有效
    ,checkdept -- 核查部门1-互联网银行事业部2-个人银行部3-公司银行部4-零售信贷部5-金融市场部6-授信审批部7-微贷产品事业部8-交易银行部9-同业银行部10-汕头分行银行部
    ,checktype -- 核查类型
    ,photo -- 照片流
    ,businesstype -- 业务种类
    ,trantype -- 交易类型
    ,chkrspmsg -- 核查结果信息
    ,transeqno -- 中台流水
    ,loadflg -- 导出标识：0-初始化；1-已导出；2-导出中
    ,dealflg -- 处理标识：0-未处理；1-已核查；2-核查中
    ,feecntflg -- 费用统计标识：0-未统计；1-已统计
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.mpcs_a60tchkbatdetail
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.mpcs_a60tchkbatdetail exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a60tchkbatdetail_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a60tchkbatdetail to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.mpcs_a60tchkbatdetail_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a60tchkbatdetail',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);