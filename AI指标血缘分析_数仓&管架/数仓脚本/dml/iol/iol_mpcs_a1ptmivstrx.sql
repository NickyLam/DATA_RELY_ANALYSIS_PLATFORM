/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a1ptmivstrx
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
drop table ${iol_schema}.mpcs_a1ptmivstrx_ex purge;
alter table ${iol_schema}.mpcs_a1ptmivstrx add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.mpcs_a1ptmivstrx;

-- 2.3 insert data to ex table
create table ${iol_schema}.mpcs_a1ptmivstrx_ex nologging
compress
as
select * from ${iol_schema}.mpcs_a1ptmivstrx where 0=1;

insert /*+ append */ into ${iol_schema}.mpcs_a1ptmivstrx_ex(
    transdt -- 交易日期
    ,transtm -- 交易时间
    ,pckno -- 报文类型
    ,sndbrn -- 发送行
    ,sndupbrn -- 发送清算行
    ,rcvbrn -- 接收行
    ,rcvupbrn -- 接收清算行
    ,consigndt -- 委托日期
    ,transseq -- 报文标识号
    ,msgrefid -- 通信级参考号
    ,iotype -- 来往标识 0-往 1-来
    ,mobnb -- 手机号
    ,entprs -- 市场主体类型码
    ,nm -- 名称
    ,nmoflglprsn -- 法定代表人或单位负责人姓名
    ,tranm -- 字号名称
    ,idtp -- 证件类型
    ,id -- 证件号
    ,unisoccdtcd -- 统一社会信用代码
    ,bizregnb -- 工商注册号
    ,txpyridnb -- 纳税人识别号
    ,agtnm -- 代理人姓名
    ,agtid -- 代理人身份证件号码
    ,opnm -- 操作员姓名
    ,margbrn -- 处理机构
    ,tlrno -- 处理柜员
    ,srcseqno -- 渠道流水
    ,sysind -- 核查系统标识
    ,quedt -- 系统受理查询日期
    ,acctsts -- 企业账户状态：OPEN：已开户 CLOS：已销户
    ,chngdt -- 企业账户状态变更日期
    ,orgdlvrgtransseq -- 疑义反馈原报文标识号
    ,cntt -- 疑义反馈内容
    ,contactnm -- 联系人姓名
    ,contactnb -- 联系人电话
    ,rcvdt -- 接收日期
    ,rcvtm -- 接收时间
    ,msgid -- 回执报文标识号
    ,procsts -- 人行处理状态
    ,proccd -- 人行处理码
    ,rslt -- 核查结果
    ,mobcrr -- 手机运营商
    ,locmobnb -- 手机号归属地代码
    ,cdtp -- 客户类型
    ,locnmmobnb -- 手机号归属地名称
    ,sts -- 手机号码状态
    ,dataresrcdt -- 数据源日期
    ,cotp -- 市场主体类型
    ,dom -- 住所
    ,regcptl -- 注册资本(金)
    ,dtest -- 成立日期
    ,opprdfrom -- 经营期限自
    ,opprdto -- 经营期限至
    ,regsts -- 登记状态
    ,regauth -- 登记机关
    ,bizscp -- 经营范围
    ,dtappr -- 核准日期
    ,status -- 状态 Z-初始登记 S-已发送人行待回执 U-发送人行失败或者超时 T-人行已回执成功 R-被人行拒绝 E-交易失败
    ,errmsg -- 错误信息
    ,appendtable -- 附加数据表名
    ,lastpgind -- 最后一页指示符:true-最后一页 ；false-不是最后一页
    ,ttlpgnb -- 总页数
    ,curpgnb -- 当前页数
    ,vrytp -- 身份核查类型
    ,valtp -- 身份证有效期类型
    ,issdt -- 有效期起始日期
    ,exprdt -- 有效期截止日期
    ,piclen -- 照片数据长度
    ,picfile -- 照片存放位置
    ,picvryrslt -- 人像核查结果
    ,picchkinf -- 人像核查结果描述
    ,simsco -- 人像比对分值
    ,busclass -- 业务大类
    ,busclassdes -- 业务大类名称
    ,subclass -- 业务小类
    ,subclassdes -- 业务小类名称
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    transdt -- 交易日期
    ,transtm -- 交易时间
    ,pckno -- 报文类型
    ,sndbrn -- 发送行
    ,sndupbrn -- 发送清算行
    ,rcvbrn -- 接收行
    ,rcvupbrn -- 接收清算行
    ,consigndt -- 委托日期
    ,transseq -- 报文标识号
    ,msgrefid -- 通信级参考号
    ,iotype -- 来往标识 0-往 1-来
    ,mobnb -- 手机号
    ,entprs -- 市场主体类型码
    ,nm -- 名称
    ,nmoflglprsn -- 法定代表人或单位负责人姓名
    ,tranm -- 字号名称
    ,idtp -- 证件类型
    ,id -- 证件号
    ,unisoccdtcd -- 统一社会信用代码
    ,bizregnb -- 工商注册号
    ,txpyridnb -- 纳税人识别号
    ,agtnm -- 代理人姓名
    ,agtid -- 代理人身份证件号码
    ,opnm -- 操作员姓名
    ,margbrn -- 处理机构
    ,tlrno -- 处理柜员
    ,srcseqno -- 渠道流水
    ,sysind -- 核查系统标识
    ,quedt -- 系统受理查询日期
    ,acctsts -- 企业账户状态：OPEN：已开户 CLOS：已销户
    ,chngdt -- 企业账户状态变更日期
    ,orgdlvrgtransseq -- 疑义反馈原报文标识号
    ,cntt -- 疑义反馈内容
    ,contactnm -- 联系人姓名
    ,contactnb -- 联系人电话
    ,rcvdt -- 接收日期
    ,rcvtm -- 接收时间
    ,msgid -- 回执报文标识号
    ,procsts -- 人行处理状态
    ,proccd -- 人行处理码
    ,rslt -- 核查结果
    ,mobcrr -- 手机运营商
    ,locmobnb -- 手机号归属地代码
    ,cdtp -- 客户类型
    ,locnmmobnb -- 手机号归属地名称
    ,sts -- 手机号码状态
    ,dataresrcdt -- 数据源日期
    ,cotp -- 市场主体类型
    ,dom -- 住所
    ,regcptl -- 注册资本(金)
    ,dtest -- 成立日期
    ,opprdfrom -- 经营期限自
    ,opprdto -- 经营期限至
    ,regsts -- 登记状态
    ,regauth -- 登记机关
    ,bizscp -- 经营范围
    ,dtappr -- 核准日期
    ,status -- 状态 Z-初始登记 S-已发送人行待回执 U-发送人行失败或者超时 T-人行已回执成功 R-被人行拒绝 E-交易失败
    ,errmsg -- 错误信息
    ,appendtable -- 附加数据表名
    ,lastpgind -- 最后一页指示符:true-最后一页 ；false-不是最后一页
    ,ttlpgnb -- 总页数
    ,curpgnb -- 当前页数
    ,vrytp -- 身份核查类型
    ,valtp -- 身份证有效期类型
    ,issdt -- 有效期起始日期
    ,exprdt -- 有效期截止日期
    ,piclen -- 照片数据长度
    ,picfile -- 照片存放位置
    ,picvryrslt -- 人像核查结果
    ,picchkinf -- 人像核查结果描述
    ,simsco -- 人像比对分值
    ,busclass -- 业务大类
    ,busclassdes -- 业务大类名称
    ,subclass -- 业务小类
    ,subclassdes -- 业务小类名称
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.mpcs_a1ptmivstrx
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.mpcs_a1ptmivstrx exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a1ptmivstrx_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a1ptmivstrx to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.mpcs_a1ptmivstrx_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a1ptmivstrx',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);