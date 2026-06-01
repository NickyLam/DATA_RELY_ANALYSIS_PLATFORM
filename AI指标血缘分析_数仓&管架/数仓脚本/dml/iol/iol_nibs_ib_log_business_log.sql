/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nibs_ib_log_business_log
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
drop table ${iol_schema}.nibs_ib_log_business_log_ex purge;
alter table ${iol_schema}.nibs_ib_log_business_log add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
-- 2.2.1 get new data into table
set serveroutput on
declare bat_dt varchar2(10);
    v_p_exists varchar2(10);
    v_sql varchar2(200);
begin    
for i in 0 .. 14 loop
    bat_dt := to_char(to_date('${batch_date}','yyyymmdd') - i,'yyyymmdd');
    v_sql := 'select count(0) from user_tab_partitions where table_name = upper(''nibs_ib_log_business_log'') and PARTITION_NAME = ''P_'||bat_dt||''' ';
    execute immediate v_sql into v_p_exists;
    -- exists patitions
    if v_p_exists = 1 then 
        v_sql := 'alter table iol.nibs_ib_log_business_log truncate partition p_'||bat_dt ;
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
    --no exists partitions  
    else 
        v_sql := 'alter table iol.nibs_ib_log_business_log add partition p_'||bat_dt||' values (to_date('''||bat_dt||''',''yyyymmdd'')) ';
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
    end if;
      end loop;
end;
/


-- 2.3 insert data to ex table
create table ${iol_schema}.nibs_ib_log_business_log_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nibs_ib_log_business_log where 0=1;

insert /*+ append */ into ${iol_schema}.nibs_ib_log_business_log(
    tx_seq_num -- 业务流水号(交易订单号)
    ,core_tran_flow_num -- 全局流水号
    ,chan_biz_seq_num -- 渠道方系统流水号
    ,p_biz_seq_num -- 协同平台流水号
    ,backserialnum -- 后台流水号
    ,custserialnum -- 客户服务流水号
    ,sys_num -- 系统编号
    ,app_num -- 应用编号
    ,chan_num -- 渠道编号
    ,channeldate -- 渠道日期
    ,channeltime -- 渠道时间
    ,channelip -- 渠道ip
    ,channelmac -- mac地址
    ,oidinfo -- 交易终端编号
    ,channeltrancode -- 渠道交易码
    ,channeltranname -- 渠道交易名称
    ,channeltrantype -- 交易类型
    ,tx_org_num -- 交易机构编号
    ,tx_org_name -- 交易机构名称
    ,teller_flag -- 高低柜标识
    ,tx_teller_num -- 交易柜员编号
    ,tx_teller_name -- 柜员名称
    ,auth_tel_num -- 授权柜员编号
    ,auth_tel_name -- 授权柜员名称
    ,auth_flow_num -- 授权流水号
    ,auth_mould -- 授权模式
    ,islangtran -- 是否长流程交易
    ,markworknum -- 营销工号
    ,cust_type_cd -- 客户类型
    ,cust_num -- 客户编号
    ,cn_name -- 客户名称
    ,cert_type_cd -- 证件类型
    ,cert_num -- 证件号码
    ,acct_num -- 账户编号
    ,acct_name -- 账号名称
    ,tx_curr_cd -- 交易币种
    ,tx_amt -- 交易金额
    ,debit_crdt_ind -- 借贷标志
    ,cash_trans_flg -- 现转标志
    ,networkchkserno -- 联网核查流水号
    ,networkchkresult -- 联网核查结果
    ,faceidentresult -- 人脸识别结果
    ,faceidentscore -- 人脸识别分数
    ,cntpty_type_cd -- 交易对手类别
    ,cntpty_id -- 交易对手编号
    ,tx_cntpty_acct_num -- 交易对手账号
    ,tx_cntpty_name -- 交易对手名称
    ,isagent -- 是否代理 0-否 1-是
    ,agent_person_name -- 代办人名称
    ,agent_person_cert_type_cd -- 代办人证件类型
    ,agent_person_cert_num -- 代办人证件号码
    ,agent_person_tel_num -- 代办人手机号或代办人电话号码
    ,agent_person_nation_cd -- 代办人国籍
    ,agent_gender_cd -- 代办人性别
    ,agent_career_typeone_code -- 代办人职业-分类1代码
    ,agent_career_typetwo_code -- 代办人职业-分类2代码
    ,agent_career_typeone -- 代办人职业-分类1名称
    ,agent_career_typetwo -- 代办人职业-分类2名称
    ,agent_career_cd -- 代办人职业（详细说明）
    ,agent_person_provincecode -- 代办人联系地址-省代码
    ,agent_person_citycode -- 代办人联系地址-市代码
    ,agent_person_countycode -- 代办人联系地址-区代码
    ,agent_person_province -- 代办人联系地址-省名称
    ,agent_person_city -- 代办人联系地址-市名称
    ,agent_person_county -- 代办人联系地址-区名称
    ,agent_person_auth_adr -- 代办人发证机关地址
    ,agent_person_contact_adr -- 代办人联系地址（详细地址）
    ,agent_person_start_dt -- 代办人证件开始日期
    ,agent_person_end_dt -- 代办人证件到期日期
    ,agent_person_networkchk_serno -- 代办人联网核查流水号
    ,agent_person_networkchk_ret -- 代办人联网核查结果
    ,agent_person_faceident_res -- 代办人人脸识别结果
    ,agent_person_faceident_score -- 代办人人脸识别分数
    ,agent_person_reason -- 代办理由
    ,vouchernum -- 凭证资料数量
    ,blendingstatu -- 勾兑状态 0-未勾兑、1-已勾兑，2-部分勾兑，
    ,blendingtype -- 勾兑方式 0-手动，1-自动，2-手动+自动
    ,p_workdate -- 协同平台工作日期
    ,p_worktime -- 协同平台工作时间
    ,transtate -- 交易状态 s-成功 f-失败
    ,returncode -- 返回码
    ,returndesc -- 返回描述
    ,remark -- 备注
    ,purpose -- 用途
    ,coredate -- 核心日期
    ,apporveno -- 业务审批单号
    ,reunique_seq_num -- 关联业务流水号
    ,note1 -- 备用1
    ,keybusiness -- 重点业务标识
    ,note2 -- 备用2
    ,blendingdesc -- 勾兑说明
    ,biz_scene -- 影像场景码
    ,blip_id -- 影像编号
    ,financeflag -- 一次性金融服务标识|N-否 Y-是
    ,attachorgan -- 柜员所属机构
    ,transtarttime -- 交易开始时间
    ,tranendtime -- 交易结束时间
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    tx_seq_num -- 业务流水号(交易订单号)
    ,core_tran_flow_num -- 全局流水号
    ,chan_biz_seq_num -- 渠道方系统流水号
    ,p_biz_seq_num -- 协同平台流水号
    ,backserialnum -- 后台流水号
    ,custserialnum -- 客户服务流水号
    ,sys_num -- 系统编号
    ,app_num -- 应用编号
    ,chan_num -- 渠道编号
    ,channeldate -- 渠道日期
    ,channeltime -- 渠道时间
    ,channelip -- 渠道ip
    ,channelmac -- mac地址
    ,oidinfo -- 交易终端编号
    ,channeltrancode -- 渠道交易码
    ,channeltranname -- 渠道交易名称
    ,channeltrantype -- 交易类型
    ,tx_org_num -- 交易机构编号
    ,tx_org_name -- 交易机构名称
    ,teller_flag -- 高低柜标识
    ,tx_teller_num -- 交易柜员编号
    ,tx_teller_name -- 柜员名称
    ,auth_tel_num -- 授权柜员编号
    ,auth_tel_name -- 授权柜员名称
    ,auth_flow_num -- 授权流水号
    ,auth_mould -- 授权模式
    ,islangtran -- 是否长流程交易
    ,markworknum -- 营销工号
    ,cust_type_cd -- 客户类型
    ,cust_num -- 客户编号
    ,cn_name -- 客户名称
    ,cert_type_cd -- 证件类型
    ,cert_num -- 证件号码
    ,acct_num -- 账户编号
    ,acct_name -- 账号名称
    ,tx_curr_cd -- 交易币种
    ,tx_amt -- 交易金额
    ,debit_crdt_ind -- 借贷标志
    ,cash_trans_flg -- 现转标志
    ,networkchkserno -- 联网核查流水号
    ,networkchkresult -- 联网核查结果
    ,faceidentresult -- 人脸识别结果
    ,faceidentscore -- 人脸识别分数
    ,cntpty_type_cd -- 交易对手类别
    ,cntpty_id -- 交易对手编号
    ,tx_cntpty_acct_num -- 交易对手账号
    ,tx_cntpty_name -- 交易对手名称
    ,isagent -- 是否代理 0-否 1-是
    ,agent_person_name -- 代办人名称
    ,agent_person_cert_type_cd -- 代办人证件类型
    ,agent_person_cert_num -- 代办人证件号码
    ,agent_person_tel_num -- 代办人手机号或代办人电话号码
    ,agent_person_nation_cd -- 代办人国籍
    ,agent_gender_cd -- 代办人性别
    ,agent_career_typeone_code -- 代办人职业-分类1代码
    ,agent_career_typetwo_code -- 代办人职业-分类2代码
    ,agent_career_typeone -- 代办人职业-分类1名称
    ,agent_career_typetwo -- 代办人职业-分类2名称
    ,agent_career_cd -- 代办人职业（详细说明）
    ,agent_person_provincecode -- 代办人联系地址-省代码
    ,agent_person_citycode -- 代办人联系地址-市代码
    ,agent_person_countycode -- 代办人联系地址-区代码
    ,agent_person_province -- 代办人联系地址-省名称
    ,agent_person_city -- 代办人联系地址-市名称
    ,agent_person_county -- 代办人联系地址-区名称
    ,agent_person_auth_adr -- 代办人发证机关地址
    ,agent_person_contact_adr -- 代办人联系地址（详细地址）
    ,agent_person_start_dt -- 代办人证件开始日期
    ,agent_person_end_dt -- 代办人证件到期日期
    ,agent_person_networkchk_serno -- 代办人联网核查流水号
    ,agent_person_networkchk_ret -- 代办人联网核查结果
    ,agent_person_faceident_res -- 代办人人脸识别结果
    ,agent_person_faceident_score -- 代办人人脸识别分数
    ,agent_person_reason -- 代办理由
    ,vouchernum -- 凭证资料数量
    ,blendingstatu -- 勾兑状态 0-未勾兑、1-已勾兑，2-部分勾兑，
    ,blendingtype -- 勾兑方式 0-手动，1-自动，2-手动+自动
    ,p_workdate -- 协同平台工作日期
    ,p_worktime -- 协同平台工作时间
    ,transtate -- 交易状态 s-成功 f-失败
    ,returncode -- 返回码
    ,returndesc -- 返回描述
    ,remark -- 备注
    ,purpose -- 用途
    ,coredate -- 核心日期
    ,apporveno -- 业务审批单号
    ,reunique_seq_num -- 关联业务流水号
    ,note1 -- 备用1
    ,keybusiness -- 重点业务标识
    ,note2 -- 备用2
    ,blendingdesc -- 勾兑说明
    ,biz_scene -- 影像场景码
    ,blip_id -- 影像编号
    ,financeflag -- 一次性金融服务标识|N-否 Y-是
    ,attachorgan -- 柜员所属机构
    ,transtarttime -- 交易开始时间
    ,tranendtime -- 交易结束时间
    ,channeldate as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.nibs_ib_log_business_log
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table


-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nibs_ib_log_business_log to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.nibs_ib_log_business_log_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nibs_ib_log_business_log',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);