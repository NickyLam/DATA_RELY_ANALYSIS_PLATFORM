/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol imps_yx_act_join_detail_out
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.imps_yx_act_join_detail_out
whenever sqlerror continue none;
drop table ${iol_schema}.imps_yx_act_join_detail_out purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.imps_yx_act_join_detail_out(
    p_date date -- 分区日期
    ,hostcustno varchar2(4000) -- 银行客户号
    ,actid varchar2(4000) -- 活动编号
    ,actname varchar2(4000) -- 活动名称
    ,tooltypename varchar2(4000) -- 工具类型名称
    ,jointime varchar2(4000) -- 参与时间
    ,score varchar2(4000) -- 分数
    ,gametime varchar2(4000) -- 用时（s）
    ,whethersuccess varchar2(4000) -- 挑战结果(成功/失败)
    ,winning varchar2(4000) -- 是否中奖
    ,orderno varchar2(4000) -- 订单编号
    ,prizename varchar2(4000) -- 礼品名称
    ,receiveinvalidtime varchar2(4000) -- 领取有效期
    ,orderstatus varchar2(4000) -- 订单状态
    ,cardcouponsexpirationdate varchar2(4000) -- 卡券有效期
    ,cardcouponswriteoffdate varchar2(4000) -- 卡券核销时间
    ,pricemoney varchar2(4000) -- 礼品价值
    ,signreward varchar2(4000) -- 签到奖励
    ,guessstate varchar2(4000) -- 竞猜结果
    ,guesswinpoints varchar2(4000) -- 奖励数
    ,inviteeshostcustno varchar2(4000) -- 被邀请人客户号
    ,invitationstatus varchar2(4000) -- 邀请状态
    ,votingworkname varchar2(4000) -- 参赛作品名称
    ,receivedvotes varchar2(4000) -- 收到投票数
    ,lootjoinnumber varchar2(4000) -- 夺宝号
    ,consumptiontotalpoints varchar2(4000) -- 捐赠总消耗
    ,donattotalcount varchar2(4000) -- 捐赠总笔数
    ,totalguesscount varchar2(4000) -- 竞猜次数
    ,guesssuccesscount varchar2(4000) -- 竞猜正确次数
    ,totalguesssuccesspoints varchar2(4000) -- 获得奖励累计
    ,datatime varchar2(4000) -- 数据日期
    ,returntime varchar2(4000) -- 回流日期
    ,baseid number(22,0) -- 
    ,row_id number(22,0) -- 数据行号
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.imps_yx_act_join_detail_out to ${iml_schema};
grant select on ${iol_schema}.imps_yx_act_join_detail_out to ${icl_schema};
grant select on ${iol_schema}.imps_yx_act_join_detail_out to ${idl_schema};
grant select on ${iol_schema}.imps_yx_act_join_detail_out to ${iel_schema};

-- comment
comment on table ${iol_schema}.imps_yx_act_join_detail_out is 'NGN活动领奖信息表';
comment on column ${iol_schema}.imps_yx_act_join_detail_out.p_date is '分区日期';
comment on column ${iol_schema}.imps_yx_act_join_detail_out.hostcustno is '银行客户号';
comment on column ${iol_schema}.imps_yx_act_join_detail_out.actid is '活动编号';
comment on column ${iol_schema}.imps_yx_act_join_detail_out.actname is '活动名称';
comment on column ${iol_schema}.imps_yx_act_join_detail_out.tooltypename is '工具类型名称';
comment on column ${iol_schema}.imps_yx_act_join_detail_out.jointime is '参与时间';
comment on column ${iol_schema}.imps_yx_act_join_detail_out.score is '分数';
comment on column ${iol_schema}.imps_yx_act_join_detail_out.gametime is '用时（s）';
comment on column ${iol_schema}.imps_yx_act_join_detail_out.whethersuccess is '挑战结果(成功/失败)';
comment on column ${iol_schema}.imps_yx_act_join_detail_out.winning is '是否中奖';
comment on column ${iol_schema}.imps_yx_act_join_detail_out.orderno is '订单编号';
comment on column ${iol_schema}.imps_yx_act_join_detail_out.prizename is '礼品名称';
comment on column ${iol_schema}.imps_yx_act_join_detail_out.receiveinvalidtime is '领取有效期';
comment on column ${iol_schema}.imps_yx_act_join_detail_out.orderstatus is '订单状态';
comment on column ${iol_schema}.imps_yx_act_join_detail_out.cardcouponsexpirationdate is '卡券有效期';
comment on column ${iol_schema}.imps_yx_act_join_detail_out.cardcouponswriteoffdate is '卡券核销时间';
comment on column ${iol_schema}.imps_yx_act_join_detail_out.pricemoney is '礼品价值';
comment on column ${iol_schema}.imps_yx_act_join_detail_out.signreward is '签到奖励';
comment on column ${iol_schema}.imps_yx_act_join_detail_out.guessstate is '竞猜结果';
comment on column ${iol_schema}.imps_yx_act_join_detail_out.guesswinpoints is '奖励数';
comment on column ${iol_schema}.imps_yx_act_join_detail_out.inviteeshostcustno is '被邀请人客户号';
comment on column ${iol_schema}.imps_yx_act_join_detail_out.invitationstatus is '邀请状态';
comment on column ${iol_schema}.imps_yx_act_join_detail_out.votingworkname is '参赛作品名称';
comment on column ${iol_schema}.imps_yx_act_join_detail_out.receivedvotes is '收到投票数';
comment on column ${iol_schema}.imps_yx_act_join_detail_out.lootjoinnumber is '夺宝号';
comment on column ${iol_schema}.imps_yx_act_join_detail_out.consumptiontotalpoints is '捐赠总消耗';
comment on column ${iol_schema}.imps_yx_act_join_detail_out.donattotalcount is '捐赠总笔数';
comment on column ${iol_schema}.imps_yx_act_join_detail_out.totalguesscount is '竞猜次数';
comment on column ${iol_schema}.imps_yx_act_join_detail_out.guesssuccesscount is '竞猜正确次数';
comment on column ${iol_schema}.imps_yx_act_join_detail_out.totalguesssuccesspoints is '获得奖励累计';
comment on column ${iol_schema}.imps_yx_act_join_detail_out.datatime is '数据日期';
comment on column ${iol_schema}.imps_yx_act_join_detail_out.returntime is '回流日期';
comment on column ${iol_schema}.imps_yx_act_join_detail_out.baseid is '';
comment on column ${iol_schema}.imps_yx_act_join_detail_out.row_id is '数据行号';
comment on column ${iol_schema}.imps_yx_act_join_detail_out.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.imps_yx_act_join_detail_out.etl_timestamp is 'ETL处理时间戳';
